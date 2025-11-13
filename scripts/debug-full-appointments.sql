-- Debug: Ver estrutura dos dados de appointments
SELECT 
  a.id,
  a.patient_id,
  a.doctor_id,
  a.appointment_date,
  a.status,
  a.reason,
  p_patient.name as nome_paciente,
  p_doctor.name as nome_medico
FROM public.appointments a
LEFT JOIN public.profiles p_patient ON a.patient_id = p_patient.id
LEFT JOIN public.profiles p_doctor ON a.doctor_id = p_doctor.id
ORDER BY a.appointment_date DESC;

-- Ver se existem registros de staff também
SELECT 
  s.id,
  s.user_id,
  s.specialty,
  s.registration_number,
  s.status as staff_status,
  p.name as nome_profissional
FROM public.staff s
LEFT JOIN public.profiles p ON s.user_id = p.id;
