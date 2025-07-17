// insuranceFilters.js

// Script to ensure type="date" for date inputs
window.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('input.date-input').forEach(input => {
        input.setAttribute('type', 'date');
    });
});

// Function to scroll to the table
function scrollToTable() {
    // Corrected selector to match JSF's generated ID for the table
    // Assuming your form ID is 'insuranceForm' and table ID is 'insuranceTable'
    const table = document.getElementById('insuranceForm:insuranceTable'); 
    if (table) {
        const offset = 80; // Adjust for navbar height
        const tablePosition = table.getBoundingClientRect().top + window.pageYOffset - offset;
        window.scrollTo({
            top: tablePosition,
            behavior: 'smooth'
        });
    }
}

// Call scroll to table AND apply active filter on page load (crucial for postbacks)
// Using DOMContentLoaded is generally preferred over window.onload for faster execution
// as it waits only for the DOM to be ready, not all images/resources.
window.addEventListener('DOMContentLoaded', function() { // Changed to DOMContentLoaded
    // Call applyActiveFilterFromStorage on DOM ready
    applyActiveFilterFromStorage();

    // Call scroll to table after filter is applied
    // Ensure table exists before trying to scroll
    const table = document.getElementById('insuranceForm:insuranceTable');
    if (table) {
        scrollToTable();
    }
});


// --- JAVASCRIPT FOR BUTTON COLORING ---

const ACTIVE_FILTER_KEY = 'activeFilterButtonId';
const FORM_ID = 'insuranceForm'; // <--- NEW: Define your JSF form ID here

/**
 * Helper to get the full JSF ID for a button.
 * @param {string} simpleId The simple ID of the button (e.g., 'activeOnlyBtn').
 * @returns {string} The full JSF ID (e.g., 'insuranceForm:activeOnlyBtn').
 */
function getFullJSFId(simpleId) {
    // Only prepend form ID if it's not the root.
    // However, for components inside forms, it's always prepended.
    return FORM_ID + ':' + simpleId;
}

/**
 * Sets the active filter button and stores its ID in localStorage.
 * This function is called by the button's onclick.
 * @param {string} simpleButtonId The simple ID of the button that was clicked (e.g., 'activeOnlyBtn').
 */
function setActiveFilter(simpleButtonId) {
    // Get all buttons within the filter-buttons-bar that have btn class
    // We get them by their general class because their full IDs are dynamic/form-prefixed.
    document.querySelectorAll('.filter-buttons-bar .btn').forEach(btn => {
        btn.classList.remove('active-filter');
    });

    // Get the clicked button using its full JSF ID
    const fullButtonId = getFullJSFId(simpleButtonId); // <--- Use helper function
    const clickedButton = document.getElementById(fullButtonId);
    
    if (clickedButton) {
        clickedButton.classList.add('active-filter');
        // Store the active button's *simple* ID in local storage for cleaner state
        // The applyActiveFilterFromStorage will convert it back to full ID
        localStorage.setItem(ACTIVE_FILTER_KEY, simpleButtonId); 
    }
}

/**
 * Resets the active filter state and removes the highlight.
 * This function is called by the Reset button's onclick.
 */
function resetActiveFilter() {
    // Remove 'active-filter' class from all filter buttons
    document.querySelectorAll('.filter-buttons-bar .btn').forEach(btn => {
        btn.classList.remove('active-filter');
    });
    localStorage.removeItem(ACTIVE_FILTER_KEY); // Clear from local storage
}

/**
 * Applies the active filter class based on the ID stored in localStorage.
 * This function is called on page load (including after JSF postbacks).
 */
function applyActiveFilterFromStorage() {
    const storedSimpleButtonId = localStorage.getItem(ACTIVE_FILTER_KEY);
    if (storedSimpleButtonId) {
        // If the stored ID is for the reset button, call resetActiveFilter
        if (storedSimpleButtonId === 'resetFilterBtn') {
            resetActiveFilter(); // This clears localStorage and removes classes
        } else {
            // Apply the active class to the button if it exists in the current DOM
            const fullButtonIdToActivate = getFullJSFId(storedSimpleButtonId); // <--- Use helper function
            const activeBtn = document.getElementById(fullButtonIdToActivate);
            
            // Ensure all other buttons are uncolored before applying
            document.querySelectorAll('.filter-buttons-bar .btn').forEach(btn => {
                btn.classList.remove('active-filter');
            });

            if (activeBtn) {
                activeBtn.classList.add('active-filter');
            } else {
                // If the stored button ID doesn't exist on the current page (e.g., navigation to a different page, or button removed), clear storage
                localStorage.removeItem(ACTIVE_FILTER_KEY);
            }
        }
    } else {
        // If nothing is stored, ensure all buttons are uncolored
        resetActiveFilter(); // Calling this will just remove classes, won't error
    }
}