
function draw_chart(id,calendar,payments,expanses) {
    var ctx = document.getElementById(id).getContext('2d');
     new Chart(ctx, {
    type: 'line',
    data: {
        labels: calendar,
        datasets: [
        {   
            label: 'Outcome',
            backgroundColor: '#5ca135',
            borderColor: 'green',
            data: expanses
        },
        {
            label: 'Income',
            backgroundColor: 'SteelBlue',
            borderColor: 'DeepSkyBlue',
            data: payments
        }
        ]
    },
    options: {}
});

}

