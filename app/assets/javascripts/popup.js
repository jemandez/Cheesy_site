$(document).ready(function(){
  var modal = document.getElementById('myModal');
  var modalImg = document.getElementById("img");
  var captionText = document.getElementById("modal-name");
  var captionface = document.getElementById("modal-face");
  var captionphone = document.getElementById("modal-phone");
  var captionmail = document.getElementById("modal-mail");

  $(".grid-image__container__picture").click(function(){
    modal.style.display = "block";
    modalImg.src = this.src;
    captionText.innerHTML = this.name;
    captionface.innerText = this.getAttribute("face");
    captionphone.innerText = this.getAttribute("phone");
    captionmail.innerText = this.getAttribute("mail");
    $(this).parent().addClass("active");
  })

  $(".close").click(function(){
    modal.style.display = "none";
    $(".active").removeClass("active");
  })

  $(".next-image").click(function(){
    $(".active").next().addClass("active");
    $(".active").prev().removeClass("active");
    $(".active").children().click();
  });

  $(".prev-image").click(function(){
    $(".active").prev().addClass("active");
    $(".active").next().removeClass("active");
    $(".active").children().click();
  });

  $(window).click(function(){
    if (event.target == modal) {
        modal.style.display = "none";
    }
  })
})

