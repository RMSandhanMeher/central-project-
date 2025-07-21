// Shows/hides form sections based on user selection, clears irrelevant inputs
   function toggleSearchInput() {
       const searchBySelect = document.getElementById('searchForm:searchBy');
       const selectedValue = searchBySelect.value;

       const searchValueInputDiv = document.getElementById('searchForm:searchValueInputDiv');
       const specializationDropdownDiv = document.getElementById('searchForm:specializationDropdownDiv');
       const searchModeLabel = document.getElementById('searchForm:searchModeLabel');
       const searchModeRadiosDiv = document.getElementById('searchForm:searchModeRadiosDiv');

       const isSpecialization = (selectedValue === 'specialization');
       const isDoctorNameOrAddress = (selectedValue === 'doctorName' || selectedValue === 'address');

       if (searchValueInputDiv) {
           searchValueInputDiv.classList.toggle('hidden', isSpecialization);
       }

       if (specializationDropdownDiv) {
           specializationDropdownDiv.classList.toggle('hidden', !isSpecialization);
       }

       if (searchModeLabel) {
           searchModeLabel.classList.toggle('hidden', !isDoctorNameOrAddress);
       }

       if (searchModeRadiosDiv) {
           searchModeRadiosDiv.classList.toggle('hidden', !isDoctorNameOrAddress);
       }

       // Clear stale input values
       if (isSpecialization) {
           const input = document.getElementById('searchForm:searchValueInput');
           if (input) input.value = '';
       } else {
           const spec = document.getElementById('searchForm:specializationDropdown');
           if (spec && spec.options.length > 0) {
               spec.value = "";
           }
       }
   }

   //Smoothly scrolls to the results table if present
   function scrollToTable() {
       const anchor = document.getElementById('results');
       if (anchor) {
           const offset = 90; // Adjust if you have a fixed navbar
           const top = anchor.getBoundingClientRect().top + window.pageYOffset - offset;
           window.scrollTo({ top, behavior: 'smooth' });
       }
   }

   //Sets up form visibility and (if needed) scrolls to results when page loads-->
   window.onload = function () {
       
   	//Shows/hides form sections based on user selection, clears irrelevant inputs
       toggleSearchInput();

       // Scroll only when coming back to #results
       if (window.location.hash === '#results') {
           setTimeout(scrollToTable, 100);
       }
   };