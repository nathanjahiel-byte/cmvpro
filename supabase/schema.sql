-- ============================================================
-- CMV Pro — Supabase Schema
-- Restaurante do Leo · Life Ecosystem
-- ============================================================
-- Execute este script no SQL Editor do seu projeto Supabase
-- (Dashboard → SQL Editor → New Query → Cole e clique Run)
-- ============================================================

-- 1. TABELA PRINCIPAL
-- Uma linha por usuário autenticado.
-- months   → array de meses (JSON completo de cada mês)
-- thresholds → limites de alerta configuráveis pelo usuário
-- ============================================================
create table if not exists public.restaurant_data (
  id           bigint      generated always as identity primary key,
  user_id      uuid        not null unique references auth.users(id) on delete cascade,
  months       jsonb       not null default '[]'::jsonb,
  active_idx   integer     not null default 0,
  thresholds   jsonb       not null default '{}'::jsonb,
  updated_at   timestamptz not null default now()
);

-- Índice para lookup rápido por user_id
create index if not exists idx_restaurant_data_user_id
  on public.restaurant_data (user_id);

-- ============================================================
-- 2. ROW LEVEL SECURITY (RLS)
-- Cada usuário só enxerga e edita os próprios dados.
-- ============================================================
alter table public.restaurant_data enable row level security;

-- Leitura: somente o dono da linha
create policy "Usuário lê próprios dados"
  on public.restaurant_data
  for select
  using (auth.uid() = user_id);

-- Inserção: somente o próprio usuário pode inserir
create policy "Usuário insere próprios dados"
  on public.restaurant_data
  for insert
  with check (auth.uid() = user_id);

-- Atualização: somente o próprio usuário pode atualizar
create policy "Usuário atualiza próprios dados"
  on public.restaurant_data
  for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- Exclusão: somente o próprio usuário pode deletar
create policy "Usuário deleta próprios dados"
  on public.restaurant_data
  for delete
  using (auth.uid() = user_id);

-- ============================================================
-- 3. TRIGGER — atualiza updated_at automaticamente
-- ============================================================
create or replace function public.handle_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists set_updated_at on public.restaurant_data;
create trigger set_updated_at
  before update on public.restaurant_data
  for each row
  execute function public.handle_updated_at();

-- ============================================================
-- 4. CONFIGURAÇÕES DE AUTH RECOMENDADAS
-- Faça isso manualmente no Dashboard:
--   Authentication → Settings
--   ✓ Enable Email provider
--   ✓ Confirm email: DESABILITADO (simplifica o onboarding do Leo)
--     (ou habilitado se preferir segurança extra)
--   ✓ Site URL: https://seu-projeto.vercel.app
--   ✓ Redirect URLs: https://seu-projeto.vercel.app/**
-- ============================================================

-- ============================================================
-- PRONTO! Rode este script uma única vez.
-- O app se encarrega de criar e sincronizar os dados.
-- ============================================================
