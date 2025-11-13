BEGIN;

DO $$
DECLARE
  patient_id uuid := gen_random_uuid();
BEGIN
  INSERT INTO public.profiles (id, name, cpf, phone, avatar)
  VALUES (patient_id, 'Paciente Exemplo', NULL, '+5511988887777', NULL);

  INSERT INTO public.user_roles (id, user_id, role)
  VALUES (gen_random_uuid(), patient_id, 'patient');

  INSERT INTO public.appointments (id, patient_id, doctor_id, appointment_date, status, reason, notes)
  VALUES (
    gen_random_uuid(), patient_id,
    (SELECT user_id FROM public.staff WHERE user_id = '17514ac3-a390-438e-80e1-7eb462cc5505' LIMIT 1),
    now() + interval '7 days', 'scheduled', 'Consulta de rotina', 'Agendada'
  );

  INSERT INTO public.medical_records (id, patient_id, doctor_id, appointment_id, diagnosis, prescription, notes)
  VALUES (
    gen_random_uuid(), patient_id,
    (SELECT user_id FROM public.staff WHERE user_id = '17514ac3-a390-438e-80e1-7eb462cc5505' LIMIT 1),
    (SELECT id FROM public.appointments WHERE patient_id = patient_id LIMIT 1),
    'Sem anomalias', 'Paracetamol 500mg', 'Seed'
  );
END;
$$;

COMMIT;

