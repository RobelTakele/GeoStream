if (!sessionStorage.getItem('isAdmin')) {
  alert('Access denied! You must be an admin.');
  window.location.href = 'index.html';
}

document.getElementById('admin-logout').addEventListener('click', function () {
  sessionStorage.removeItem('isAdmin');
  window.location.href = 'index.html';
});

function loadUsers() {
  const request = indexedDB.open('AqB_user_management_db', 1);
  request.onsuccess = function (event) {
    const db = event.target.result;
    const transaction = db.transaction(['users'], 'readonly');
    const store = transaction.objectStore('users');
    const userTableBody = document.querySelector('#userTable tbody');

    userTableBody.innerHTML = '';
    let cursorRequest = store.openCursor();
    let count = 0;
    let userNumber = (currentPage - 1) * usersPerPage + 1; // Start counting based on current page

    cursorRequest.onsuccess = function (event) {
      const cursor = event.target.result;
      if (cursor) {
        if (
          count >= (currentPage - 1) * usersPerPage &&
          count < currentPage * usersPerPage
        ) {
          const user = cursor.value;
          const row = `<tr>
              <td>${userNumber++}</td> <!-- Increment the user number -->
              <td>${user.fullName}</td>
              <td>${user.email}</td>
              <td><button onclick="deleteUser('${user.email}')">Delete</button></td>
            </tr>`;
          userTableBody.innerHTML += row;
        }
        count++;
        cursor.continue();
      }
      updatePagination(count);
    };
  };
}

window.deleteUser = function (email) {
  if (confirm(`Are you sure you want to delete the user: ${email}?`)) {
    const request = indexedDB.open('AqB_user_management_db', 1);
    request.onsuccess = function (event) {
      const db = event.target.result;
      const transaction = db.transaction(['users'], 'readwrite');
      const store = transaction.objectStore('users');
      store.delete(email).onsuccess = function () {
        showNotification('User deleted successfully');
        loadUsers();
      };
    };
  }
};

window.onload = loadUsers;

function showNotification(message) {
  const modal = document.getElementById('notificationModal');
  const msgElement = document.getElementById('notif-message');
  const closeBtn = document.querySelector('.close-notif');

  msgElement.innerText = message;
  modal.classList.add('show');

  // Close notification on click of the close button
  closeBtn.onclick = function () {
    modal.classList.remove('show');
  };

  // Close notification if the user clicks outside the modal content
  window.onclick = function (event) {
    if (event.target === modal) {
      modal.classList.remove('show');
    }
  };

  // Automatically hide the notification after 3 seconds
  setTimeout(() => {
    modal.classList.remove('show');
  }, 3000);
}

let currentPage = 1;
const usersPerPage = 10;

function updatePagination(totalUsers) {
  const totalPages = Math.ceil(totalUsers / usersPerPage);
  document.getElementById('pageNum').innerText =
    `Page ${currentPage} of ${totalPages}`;
}

window.prevPage = function () {
  if (currentPage > 1) {
    currentPage--;
    loadUsers();
  }
};

window.nextPage = function () {
  currentPage++;
  loadUsers();
};