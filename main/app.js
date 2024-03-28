$(document).ready(function () {
    let placaAtual = '';
    let listaNormal = true;

    function toggleDepotAndVehicle(depotVisible) {
        $('.depot-pagar-veiculo').toggle(depotVisible);
        $('.pegar-veiculo').toggle(!depotVisible);
    }

    function clearGarage() {
        $(".container-garage").fadeOut('fast');
        $(".lista-carros").html("");
        placaAtual = '';
        $('#nome-do-carro').html('');
        $('.numero-placa').html('');
        $('#quilometragem').html('');
        $('.field-progressbar, .field-progressbar2, .field-progressbar3').css("width", '0%');
    }

    function updateVehicleInfo($vehicle) {
        const nomeCarro = $vehicle.find('.carro-nome').text();
        const imagem = $vehicle.data('imagem');
        const placa = $vehicle.find('.carro-placa').text();
        const quilometragem = $vehicle.find('.carro-rodagem').text();
        const lataria = $vehicle.find('.carro-lataria').text();
        const motor = $vehicle.find('.carro-motor').text();
        const combustivel = $vehicle.find('.carro-combustivel').text();

        const baseUrl = 'http://127.0.0.1:8080/garagem/';

        $('.left-carro-imagem')
            .css({"opacity": '0.8', "background-image": `url('${baseUrl}${imagem}.png')`});

        $('#nome-do-carro').html(nomeCarro);
        $('.numero-placa').html(placa);
        $('#quilometragem').html(`${quilometragem} / kmh`);
        $('.field-progressbar').css("width", `${lataria}%`);
        $('.field-progressbar2').css("width", `${motor}%`);
        $('.field-progressbar3').css("width", `${combustivel}%`);
    }

    function spawnOrPayVehicle() {
        $(".container-garage").fadeOut('fast');
        $.post("https://reborn_garage/Reborn:Depot:SpawnCarro", JSON.stringify({
            placa: placaAtual,
            lista: listaNormal,
        }));
        $('.left-carro-imagem').css({"opacity": '0', "background-image": "url('img/none.png')"});
        clearGarage();
        if (!listaNormal) {
            listaNormal = true;
        }
    }

    $(document).on('click', '.veiculo-info', function (e) {
        const $this = $(this);
        placaAtual = $this.data('placa');
        updateVehicleInfo($this);
    });

    $(document).on('click', '.depot-pagar-veiculo', function (e) {
        spawnOrPayVehicle();
    });

    $(document).on('click', '.pegar-veiculo', function (e) {
        if (placaAtual !== '') {
            spawnOrPayVehicle();
        } else {
            console.log('');
        }
    });

    $(document).on('click', '.fechar-garagem', function (e) {
        $(".container-garage").fadeOut('fast');
        $('.left-carro-imagem').css({"opacity": '0', "background-image": "url('img/none.png')"});
        clearGarage();
        $.post("https://reborn_garage/Reborn:Garagem:Close", JSON.stringify({}));
        listaNormal = true;
    });

    window.addEventListener("message", function (event) {
        const dados = event.data;
        const carroid = Math.floor(Math.random() * 100000);

        if (dados.placa === dados.carro) {
            listaNormal = false;
            // console.log('lista normal é falsa')
        }

        toggleDepotAndVehicle(dados.depot === true);

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
            clearGarage();
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
