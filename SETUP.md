# CMV Pro — Deploy Guide
**Supabase → GitHub → Vercel · 3 passos, ~10 min**

---

## PASSO 1 — Supabase (banco de dados na nuvem)

1. Acesse [supabase.com](https://supabase.com) e crie uma conta gratuita
2. Clique **New Project** → dê um nome (ex: `cmvpro-leo`) → escolha região **South America (São Paulo)**
3. Anote a senha do banco (você não vai precisar dela, mas guarde)
4. Aguarde o projeto inicializar (~2 min)

**Criar a tabela:**
5. No menu lateral → **SQL Editor** → **New Query**
6. Cole o conteúdo de `supabase/schema.sql` → clique **Run**
7. Deve aparecer: *"Success. No rows returned"*

**Pegar as credenciais do app:**
8. Menu lateral → **Project Settings** → **API**
9. Copie:
   - **Project URL** → algo como `https://xyzxyz.supabase.co`
   - **anon / public key** → chave longa começando com `eyJ...`

**Configurar Auth (opcional mas recomendado):**
10. Menu lateral → **Authentication** → **Settings**
11. Em *Email Auth*: desabilite **Confirm email** (simplifica o cadastro do Leo)
12. Em *URL Configuration*: cole a URL do Vercel quando tiver (ex: `https://cmvpro.vercel.app`)

---

## PASSO 2 — GitHub (versionamento)

1. Acesse [github.com](https://github.com) e crie uma conta (ou use a sua)
2. Clique **+** → **New repository**
   - Nome: `cmvpro` (ou qualquer nome)
   - Visibilidade: **Private** (recomendado)
   - Clique **Create repository**
3. No terminal do seu computador, dentro da pasta do projeto:

```bash
git init
git add .
git commit -m "CMV Pro v2 — Supabase + Vercel"
git branch -M main
git remote add origin https://github.com/SEU_USUARIO/cmvpro.git
git push -u origin main
```

> **Segurança:** As credenciais do Supabase **não estão no código** — o app pede na primeira vez que abrir e salva no navegador do Leo. O repositório é seguro para ser público ou privado.

---

## PASSO 3 — Vercel (hospedagem gratuita)

1. Acesse [vercel.com](https://vercel.com) → faça login com a conta do GitHub
2. Clique **Add New → Project**
3. Selecione o repositório `cmvpro` → clique **Import**
4. Em *Framework Preset*: selecione **Other**
5. Clique **Deploy** (sem configurar nada mais — o `vercel.json` já cuida do roteamento)
6. Aguarde ~1 min → a Vercel vai gerar uma URL tipo `https://cmvpro-abc123.vercel.app`

**Domínio personalizado (opcional):**
7. Em *Settings → Domains* → adicione `cmvpro.seudominio.com.br`

---

## PRIMEIRA VEZ (Leo abrindo o app)

1. Leo acessa a URL do Vercel no celular
2. O app abre a **tela de Setup** pedindo:
   - **Supabase URL**: cole o *Project URL* do passo 1
   - **Supabase Key**: cole a *anon key* do passo 1
3. Clica **Salvar e continuar**
4. Na tela de Login: clica **Criar conta** → email + senha
5. Pronto — dados salvos na nuvem, acessíveis de qualquer dispositivo

> **Importante:** o Setup só aparece uma vez por dispositivo. As credenciais ficam salvas no navegador. Se Leo trocar de celular, vai precisar inserir as chaves de novo (ou você pode criar uma versão com as chaves já embutidas no código, já que o anon key é público por design do Supabase).

---

## Atualizações futuras

Para atualizar o app depois que estiver no ar, basta:
```bash
git add .
git commit -m "descrição da mudança"
git push
```
A Vercel detecta automaticamente e faz o novo deploy em ~30 segundos.

---

## Estrutura de arquivos

```
cmvpro/
├── app.html          # App completo (PWA single-file)
├── vercel.json       # Roteamento Vercel
└── supabase/
    └── schema.sql    # Script de criação do banco
```
