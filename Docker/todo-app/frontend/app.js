const API_BASE = 'http://localhost:4005/api';

async function loadTodos() {
  const res = await fetch(`${API_BASE}/todos`);
  const todos = await res.json();
  const list = document.getElementById('list');
  list.innerHTML = '';
  todos.forEach(t => {
    const li = document.createElement('li');
    li.textContent = t.text;
    list.appendChild(li);
  });
}

document.getElementById('addBtn').onclick = async () => {
  const input = document.getElementById('todoInput');
  const text = input.value.trim();
  if (!text) return;

  await fetch(`${API_BASE}/todos`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ text })
  });
  input.value = '';
  loadTodos();
};

loadTodos();
