-- Fix: Garantir que todos os doctor_ids em appointments têm profiles
-- Primeiro, vamos ver quais doctor_ids não têm profiles

SELECT DISTINCT a.doctor_id
FROM public.appointments a
WHERE NOT EXISTS (
  SELECT 1 FROM public.profiles p WHERE p.id = a.doctor_id
);

-- Agora, vamos criar profiles fictícios para esses doctor_ids que não têm
-- (Usar "Dr. João" como fallback name)
INSERT INTO public.profiles (id, name, cpf, phone)
SELECT DISTINCT a.doctor_id, 'Dr. João', NULL, NULL
FROM public.appointments a
WHERE NOT EXISTS (
  SELECT 1 FROM public.profiles p WHERE p.id = a.doctor_id
)
ON CONFLICT (id) DO NOTHING;

-- Verificar que funcionou
SELECT 
  a.id as appointment_id,
  a.doctor_id,
  p.name as doctor_name
FROM public.appointments a
LEFT JOIN public.profiles p ON a.doctor_id = p.id;
