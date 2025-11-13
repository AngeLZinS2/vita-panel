-- Remover e recriar o constraint de categoria do inventory

-- 1. Remover o constraint
ALTER TABLE public.inventory
DROP CONSTRAINT IF EXISTS inventory_category_check CASCADE;

-- 2. Recriar com todas as categorias possíveis (português + inglês)
ALTER TABLE public.inventory
ADD CONSTRAINT inventory_category_check
CHECK (category IN (
  'medication', 'equipment', 'supply', 'other',
  'medicamento', 'equipamento', 'suprimento', 'descartaveis', 'outro'
));

-- 3. Verificar se funcionou
SELECT COUNT(*) FROM public.inventory;
