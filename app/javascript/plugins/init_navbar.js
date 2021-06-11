import $ from 'jquery';

const initNavbar = () => {
  
    // Transition effect for navbar 
    window.addEventListener("scroll", (event) => {
        /* console.log(this.scrollY); */
    });
    $(window).scroll(function() {
      // checks if window is scrolled more than 500px, adds/removes solid class
      if($(this).scrollTop() > 50) { 
          $('.navbar').addClass('solid');
      } else {
          $('.navbar').removeClass('solid');
      }
    });

};


export { initNavbar };

