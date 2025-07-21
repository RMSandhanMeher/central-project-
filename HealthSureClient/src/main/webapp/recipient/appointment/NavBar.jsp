<script src="https://cdn.tailwindcss.com"></script>

<nav
	class="
    bg-white
    backdrop-blur-md
    text-gray-800
    px-6
    py-4
    rounded-2xl
    shadow-lg
    mb-6
    border
    border-gray-200
    fixed          
    top-24          
    left-1/2        
    -translate-x-1/2 
    z-50            
    w-fit           
">

	<div
		class="px-10 max-w-screen-xl mx-auto flex justify-center items-center">
		<div class="space-x-4 flex">
			<a href="${pageContext.request.contextPath}/recipient/SearchProviders.jsf"
				class="text-nowrap hover:bg-gray-200 px-4 py-2 rounded-xl transition duration-200 border border-gray-300">
				Select Doctor</a> <a href="${pageContext.request.contextPath}/recipient/appointment/doctorAvailabilityList.jsf"
				class="text-nowrap hover:bg-gray-200 bg-gray-50 px-4 py-2 rounded-xl transition duration-200 border border-gray-300">
				Book Appointment </a> <a href="${pageContext.request.contextPath}/recipient/appointment/recipient-appointments.jsf"
				class="text-nowrap hover:bg-gray-300 bg-gray-100 px-4 py-2 rounded-xl transition duration-200 border border-gray-300">
				My Appointments </a>
		</div>
	</div>

</nav>