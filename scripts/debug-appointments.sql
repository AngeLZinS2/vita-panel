-- Debug script: Ver exatamente os agendamentos no banco
SELECT 
  id,
  patient_id,
  doctor_id,
  appointment_date,
  appointment_date AT TIME ZONE 'America/Sao_Paulo' as horario_sp,
  status,
  reason
FROM public.appointments
ORDER BY appointment_date DESC;

-- Ver também o formato da data/hora
SELECT 
  appointment_date,
  to_char(appointment_date, 'YYYY-MM-DD HH24:MI:SS') as formato_legivel,
  EXTRACT(HOUR FROM appointment_date) as hora,
  EXTRACT(MINUTE FROM appointment_date) as minuto
FROM public.appointments;
