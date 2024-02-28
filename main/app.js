var placaatual = ''
var listanormal = true

$(document).ready(function () {
    window.addEventListener("message", function (event) {
        const dados = event.data;
        const carroid = Math.floor(Math.random() * 100000);

        if (dados.placa === dados.carro) {
            listanormal = false;
            // console.log('lista normal é falsa')
        }

        const depotVisible = dados.depot === true;
        $('.depot-pagar-veiculo').toggle(depotVisible);
        $('.pegar-veiculo').toggle(!depotVisible);

        const modelo = `
          <div class="veiculo-info carro-id-${carroid}">
               <div class="container-carro-info">
                    <div class="titulo-placa">${dados.placa}</div>
                    <div class="titulo-carro">${dados.carro}</div>
                    <div class="titulo-status">Status: ${dados.status}</div>
               </div>
               <span class="carro-nome" style="display: none;">${dados.carro}</span>
               <span class="carro-placa" style="display: none;">${dados.placa}</span>
               <span class="carro-rodagem" style="display: none;">${dados.kmh}</span>
               <span class="carro-status" style="display: none;">${dados.status}</span>
               <span class="carro-lataria" style="display: none;">${dados.lataria}</span>
               <span class="carro-motor" style="display: none;">${dados.motor}</span>
               <span class="carro-combustivel" style="display: none;">${dados.combustivel}</span>
          </div>`;

        if (dados.limpando === true) {
            $(".container-garage").fadeOut('fast');
            $(".lista-carros").html("");
        }

        if (dados.addcarro === true) {
            $(".container-garage").fadeIn('fast');
            $(".lista-carros").append(modelo);
            $(`.carro-id-${carroid}`).data('placa', dados.placa).data('imagem', dados.imagem);
            $('.garagem-nome').html(dados.garagem);
            $('.left-carro-imagem').css({"opacity": '0.8', "background-image": "url('img/none.png')"});
            // $(`.carro-id-${carroid}`).css({"background-image": "url('${dados.carro}.png')"});

        }
    });
});

$(document).on('click', '.veiculo-info', function (e) {
    const $this = $(this);
    const placaatual = $this.data('placa');
    const imagem = $this.data('imagem');
    const nomecarro = $this.find('.carro-nome').text();
    const quilometragem = $this.find('.carro-rodagem').text();
    const status = $this.find('.carro-status').text();
    const placa = $this.find('.carro-placa').text();
    const lataria = $this.find('.carro-lataria').text();
    const motor = $this.find('.carro-motor').text();
    const combustivel = $this.find('.carro-combustivel').text();

    const baseUrl = 'http://127.0.0.1:8080/garagem/';

    $('.left-carro-imagem')
        .css("opacity", '0.8')
        .css("background-image", `url('${baseUrl}${imagem}.png')`);

    $('#nome-do-carro').html(nomecarro);
    $('#quilometragem').html(`${quilometragem} / kmh`);
    // $('#status-carro').html(status);
    $('.numero-placa').html(placa);
    $('.field-progressbar').css("width", `${lataria}%`);
    $('.field-progressbar2').css("width", `${motor}%`);
    $('.field-progressbar3').css("width", `${combustivel}%`);
});

$(document).on('click', '.depot-pagar-veiculo', function (e) {
    $(".container-garage").fadeOut('fast');
    
    $.post("https://reborn_garage/Reborn:Depot:SpawnCarro", JSON.stringify({
        placa: placaatual,
        lista: listanormal,
    }));

    const $leftCarroImagem = $('.left-carro-imagem');
    $leftCarroImagem.css("opacity", '0');
    $leftCarroImagem.css("background-image", "url('img/none.png')");
    
    $(".lista-carros").html("");
    placaatual = '';
    $('#nome-do-carro').html('');
    $('.numero-placa').html('');
    $('#quilometragem').html('');
    // $('#status-carro').html('');
    $('.field-progressbar').css("width", '0%');
    $('.field-progressbar2').css("width", '0%');
    $('.field-progressbar3').css("width", '0%');
});


$(document).on('click', '.pegar-veiculo', function (e) {
    if (placaatual !== '') {
        $(".container-garage").fadeOut('fast');
        $.post("https://reborn_garage/Reborn:Garagem:SpawnCarro", JSON.stringify({
            placa: placaatual,
            lista: listanormal,
        }));
        $('.left-carro-imagem').css({"opacity": '0', "background-image": "url('img/none.png')"});
        $(".lista-carros").html("");
        placaatual = '';
        $('#nome-do-carro, .numero-placa, #quilometragem').html('');
        // $('#status-carro').html('');
        $('.field-progressbar, .field-progressbar2, .field-progressbar3').css("width", '0%');

        if (listanormal === false) {
            listanormal = true;
        }
    } else {
        console.log('');
    }
});

$(document).on('click', '.fechar-garagem', function (e) {
    $(".container-garage").fadeOut('fast');
    $('.left-carro-imagem').css({"opacity": '0', "background-image": "url('img/none.png')"});
    $(".lista-carros").html("");
    placaatual = '';
    $('#nome-do-carro, #quilometragem, .numero-placa').html('');
    // $('#status-carro').html('');
    $('.field-progressbar, .field-progressbar2, .field-progressbar3').css("width", '0%');
    $.post("https://reborn_garage/Reborn:Garagem:Close", JSON.stringify({}));
    listanormal = true;
});
