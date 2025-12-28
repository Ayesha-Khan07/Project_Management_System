/* ============================================
   Super Admin Dashboard JavaScript
   ============================================ */

document.addEventListener('DOMContentLoaded', function() {
  
  // ============================================
  // Search Functionality for Users Tab
  // ============================================
  const userSearch = document.getElementById('userSearch');
  if (userSearch) {
    userSearch.addEventListener('keyup', function() {
      const filter = this.value.toLowerCase();
      const rows = document.querySelectorAll('.modern-table tbody tr');
      
      rows.forEach(row => {
        const text = row.textContent.toLowerCase();
        row.style.display = text.includes(filter) ? '' : 'none';
      });
    });
  }

  // ============================================
  // Search Functionality for Companies Tab
  // ============================================
  const companySearch = document.getElementById('companySearch');
  if (companySearch) {
    companySearch.addEventListener('keyup', function() {
      const filter = this.value.toLowerCase();
      const rows = document.querySelectorAll('.modern-table tbody tr');
      
      rows.forEach(row => {
        const text = row.textContent.toLowerCase();
        row.style.display = text.includes(filter) ? '' : 'none';
      });
    });
  }

  // ============================================
  // Search Functionality for Projects Tab
  // ============================================
  const projectSearch = document.getElementById('projectSearch');
  if (projectSearch) {
    projectSearch.addEventListener('keyup', function() {
      const filter = this.value.toLowerCase();
      const rows = document.querySelectorAll('.modern-table tbody tr');
      
      rows.forEach(row => {
        const text = row.textContent.toLowerCase();
        row.style.display = text.includes(filter) ? '' : 'none';
      });
    });
  }

  // ============================================
  // Search Functionality for Tasks Tab
  // ============================================
  const taskSearch = document.getElementById('taskSearch');
  if (taskSearch) {
    taskSearch.addEventListener('keyup', function() {
      const filter = this.value.toLowerCase();
      const rows = document.querySelectorAll('.modern-table tbody tr');
      
      rows.forEach(row => {
        const text = row.textContent.toLowerCase();
        row.style.display = text.includes(filter) ? '' : 'none';
      });
    });
  }

  // ============================================
  // Smooth Scroll for Tab Navigation
  // ============================================
  const navLinks = document.querySelectorAll('.custom-tabs .nav-link');
  navLinks.forEach(link => {
    link.addEventListener('click', function(e) {
      // Allow default navigation but add smooth scroll
      setTimeout(() => {
        window.scrollTo({
          top: 0,
          behavior: 'smooth'
        });
      }, 100);
    });
  });

  // ============================================
  // Delete Button Confirmation Enhancement
  // ============================================
  const deleteButtons = document.querySelectorAll('.btn-delete');
  deleteButtons.forEach(button => {
    button.addEventListener('mouseenter', function() {
      this.style.transform = 'translateY(-2px)';
    });
    
    button.addEventListener('mouseleave', function() {
      this.style.transform = 'translateY(0)';
    });
  });

  // ============================================
  // Table Row Hover Effect Enhancement
  // ============================================
  const tableRows = document.querySelectorAll('.table-row-hover');
  tableRows.forEach(row => {
    row.addEventListener('mouseenter', function() {
      this.style.transition = 'all 0.2s ease';
    });
  });

  // ============================================
  // Animate Stat Cards on Load
  // ============================================
  const statCards = document.querySelectorAll('.stat-card');
  statCards.forEach((card, index) => {
    card.style.opacity = '0';
    card.style.transform = 'translateY(20px)';
    
    setTimeout(() => {
      card.style.transition = 'all 0.5s ease';
      card.style.opacity = '1';
      card.style.transform = 'translateY(0)';
    }, index * 100);
  });

  // ============================================
  // Progress Bar Animation
  // ============================================
  const progressBars = document.querySelectorAll('.progress-bar-custom');
  progressBars.forEach(bar => {
    const progress = bar.getAttribute('data-progress');
    bar.style.width = '0%';
    
    setTimeout(() => {
      bar.style.width = progress + '%';
    }, 300);
  });

  // ============================================
  // Search Box Focus Effect
  // ============================================
  const searchBoxes = document.querySelectorAll('.search-box input');
  searchBoxes.forEach(input => {
    input.addEventListener('focus', function() {
      this.parentElement.style.transition = 'all 0.3s ease';
    });
  });

  // ============================================
  // Toast Notification Function (Optional)
  // ============================================
  window.showToast = function(message, type = 'success') {
    const toast = document.createElement('div');
    toast.className = `toast-notification toast-${type}`;
    toast.textContent = message;
    toast.style.cssText = `
      position: fixed;
      top: 20px;
      right: 20px;
      padding: 1rem 1.5rem;
      background: ${type === 'success' ? '#10b981' : '#ef4444'};
      color: white;
      border-radius: 8px;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
      z-index: 9999;
      animation: slideInRight 0.3s ease;
    `;
    
    document.body.appendChild(toast);
    
    setTimeout(() => {
      toast.style.animation = 'slideOutRight 0.3s ease';
      setTimeout(() => {
        document.body.removeChild(toast);
      }, 300);
    }, 3000);
  };

  // ============================================
  // Debounce Function for Search
  // ============================================
  function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
      const later = () => {
        clearTimeout(timeout);
        func(...args);
      };
      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
    };
  }

  // Apply debounce to search inputs for better performance
  [userSearch, companySearch, projectSearch, taskSearch].forEach(input => {
    if (input) {
      const originalHandler = input.onkeyup;
      input.onkeyup = null;
      input.addEventListener('keyup', debounce(originalHandler || function() {
        const filter = this.value.toLowerCase();
        const rows = document.querySelectorAll('.modern-table tbody tr');
        
        rows.forEach(row => {
          const text = row.textContent.toLowerCase();
          row.style.display = text.includes(filter) ? '' : 'none';
        });
      }, 300));
    }
  });

});

// ============================================
// Add CSS Animations
// ============================================
const style = document.createElement('style');
style.textContent = `
  @keyframes slideInRight {
    from {
      transform: translateX(100%);
      opacity: 0;
    }
    to {
      transform: translateX(0);
      opacity: 1;
    }
  }

  @keyframes slideOutRight {
    from {
      transform: translateX(0);
      opacity: 1;
    }
    to {
      transform: translateX(100%);
      opacity: 0;
    }
  }
`;
document.head.appendChild(style);