document.addEventListener("turbolinks:before-cache", function() {
    if ($('#calendar').length === 1) {
        $('#calendar').fullCalendar('destroy');
    }
});

$(document).on('ready page:load', function() {
    $('#calendar').fullCalendar({
        monthNames: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'],
        monthNamesShort: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
        dayNames: ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'],
        dayNamesShort: ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'],
        eventLimit: true,
        firstDay: 1,
        minTime: "08:00:00",
        maxTime: "22:00:00",
        titleFormat: 'MMMM YYYY',
        timeFormat: 'H:mm',
        eventLimitText: '...',
        buttonText: {
            month: 'Mensual',
            agendaWeek: 'Semanal'
        },
        header: {
            left: 'prev,next',
            center: 'title',
            right: 'month,agendaWeek'
        },
        dayClick: function(date, jsEvent, view) {
            if (view.name != 'month')
                return;
            $('#calendar').fullCalendar('changeView', 'agendaDay');
            $('#calendar').fullCalendar('gotoDate', date);
        },
        eventSources: [{
            url: '/bookings.json',
            color: '#333399', // an option!
            textColor: '#fff' // an option!
        }],
        views: {
            agenda: {
                eventLimit: 1
            },
            week: {
                eventLimit: 1
            }
        },
        eventClick: function(calEvent, jsEvent, view) {

          return false;
        },
        defaultView: 'month',
        selectable: true,
        height: 560
    })
});
