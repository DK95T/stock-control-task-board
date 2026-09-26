const SUPABASE_URL = 'https://dhnkwzhglnavfeknhvok.supabase.co';
const SUPABASE_KEY = 'sb_publishable_PGzf6cIzXrPzj_SdX8_rKQ_guyTO_yt';
const TASKS_API = `${SUPABASE_URL}/rest/v1/tasks`;

async function cloudRequest(path = '', options = {}) {
  const response = await fetch(`${TASKS_API}${path}`, {
    ...options,
    headers: {
      apikey: SUPABASE_KEY,
      Authorization: `Bearer ${SUPABASE_KEY}`,
      'Content-Type': 'application/json',
      Prefer: 'return=representation',
      ...(options.headers || {})
    }
  });
  if (!response.ok) throw new Error(await response.text());
  return response.status === 204 ? null : response.json();
}

async function cloudLoadTasks() {
  return cloudRequest('?select=*&order=updated_at.desc');
}

async function cloudSaveTask(task) {
  const row = {
    id: task.id,
    order_date: task.orderDate,
    assigned_to: task.assignedTo,
    assigned_by: task.assignedBy,
    description: task.description,
    deadline: task.deadline,
    status: task.status === 'overdue' ? 'pending' : task.status,
    notes: task.notes || '',
    completion_date: task.completionDate || null,
    updated_at: new Date().toISOString()
  };
  return cloudRequest(`?on_conflict=id`, { method: 'POST', body: JSON.stringify(row), headers: { Prefer: 'resolution=merge-duplicates,return=representation' } });
}

async function cloudDeleteTask(id) {
  return cloudRequest(`?id=eq.${encodeURIComponent(id)}`, { method: 'DELETE' });
}
