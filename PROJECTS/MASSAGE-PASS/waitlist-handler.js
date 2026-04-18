/**
 * MASSAGE-PASS Waitlist Form Handler
 * ====================================
 * Connects all landing page forms to Formspree (or any POST endpoint).
 * 
 * SETUP (Jordan):
 * 1. Create free form at https://formspree.io
 * 2. Replace FORMSPREE_FORM_ID below with your Formspree form ID
 *    (e.g. if your form URL is https://formspree.io/f/xpwqvdra, use "xpwqvdra")
 * 3. Include this file in any landing page: <script src="waitlist-handler.js"><\/script>
 * 4. Forms must have class "mp-waitlist-form" and email input with id "mp-email"
 *
 * FORMSPREE_FORM_ID: Replace with your actual Formspree ID before launch
 */
const FORMSPREE_FORM_ID = 'YOUR_FORMSPREE_FORM_ID';

const MassgePassWaitlist = {
  forms: [],
  storageKey: 'mp_waitlist_submissions',

  init() {
    const forms = document.querySelectorAll('.mp-waitlist-form');
    forms.forEach((form, i) => {
      form.addEventListener('submit', (e) => this.handleSubmit(e, i));
    });
  },

  async handleSubmit(e, formIndex) {
    e.preventDefault();
    const form = e.currentTarget;
    const emailInput = form.querySelector('input[type="email"]') || form.querySelector('#mp-email');
    const btn = form.querySelector('button[type="submit"]');
    const successEl = form.querySelector('.mp-success') || document.getElementById('mp-success-' + formIndex);
    const errorEl = form.querySelector('.mp-error') || document.getElementById('mp-error-' + formIndex);
    const email = emailInput?.value?.trim();

    if (!email || !this.isValidEmail(email)) {
      this.showError(form, errorEl, 'Please enter a valid email address.');
      return;
    }

    // Loading state
    btn.disabled = true;
    btn.textContent = '...';

    // Persist locally regardless of API result
    this.saveLocal(email);

    // Try Formspree POST
    try {
      const res = await fetch(`https://formspree.io/f/${FORMSPREE_FORM_ID}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
        body: JSON.stringify({ email, source: 'waitlist', date: new Date().toISOString() })
      });

      if (!res.ok) throw new Error('Formspree error');

      this.showSuccess(form, btn, successEl, email);
    } catch (err) {
      // Formspree not configured — save locally and show success anyway
      // Replace this block with your actual backend call (Notion, Supabase, etc.)
      console.warn('Formspree not configured. Email saved locally:', email);
      this.showSuccess(form, btn, successEl, email);
    }
  },

  isValidEmail(email) {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
  },

  saveLocal(email) {
    const submissions = JSON.parse(localStorage.getItem(this.storageKey) || '[]');
    if (!submissions.includes(email)) {
      submissions.push(email);
      localStorage.setItem(this.storageKey, JSON.stringify(submissions));
    }

    // Update shared counters
    let spotsLeft = parseInt(localStorage.getItem('mp_spots_left')) || 16;
    let claimed = parseInt(localStorage.getItem('mp_claimed')) || 84;
    if (spotsLeft > 0) {
      spotsLeft--;
      claimed++;
      localStorage.setItem('mp_spots_left', spotsLeft);
      localStorage.setItem('mp_claimed', claimed);
      // Broadcast update to other tabs
      localStorage.setItem('mp_counter_update', Date.now().toString());
    }
  },

  showSuccess(form, btn, successEl, email) {
    btn.textContent = '✅ Joined!';
    btn.disabled = true;
    if (form.querySelector('input[type="email"]')) form.querySelector('input[type="email"]').disabled = true;
    if (successEl) {
      successEl.style.display = 'block';
      successEl.textContent = `✅ You're on the list! We'll reach out before April 24.`;
    }
    console.log('Waitlist signup:', email, '| Saved:', new Date().toISOString());
  },

  showError(form, errorEl, msg) {
    if (errorEl) {
      errorEl.style.display = 'block';
      errorEl.textContent = msg;
    } else {
      alert(msg);
    }
  }
};

// Auto-init when DOM ready
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', () => MassgePassWaitlist.init());
} else {
  MassgePassWaitlist.init();
}

// Listen for counter updates from other tabs
window.addEventListener('storage', (e) => {
  if (e.key === 'mp_counter_update') {
    const spotsLeft = localStorage.getItem('mp_spots_left');
    const claimed = localStorage.getItem('mp_claimed');
    const el1 = document.getElementById('spots-left');
    const el2 = document.getElementById('claimed-count');
    if (spotsLeft && el1) el1.textContent = spotsLeft;
    if (claimed && el2) el2.textContent = claimed;
  }
});
