-- Fix para o erro de duplicate key cpf vazio
-- A constraint UNIQUE em cpf não permite múltiplos valores vazios
-- Solução: alterar a constraint para NULLS NOT DISTINCT (permite múltiplos NULLs)

-- 1. Remove a constraint atual
ALTER TABLE public.profiles
DROP CONSTRAINT profiles_cpf_key;

-- 2. Recria a constraint permitindo múltiplos NULLs/vazios
ALTER TABLE public.profiles
ADD CONSTRAINT profiles_cpf_key UNIQUE (cpf) NULLS NOT DISTINCT;

-- 3. Verifique se a constraint foi criada
SELECT constraint_name, table_name
FROM information_schema.table_constraints
WHERE table_name = 'profiles' AND constraint_type = 'UNIQUE';

-- Pronto! Agora você pode criar múltiplos usuários sem CPF (cpf = '') ou NULL
