
function draw_chart(id,calendar,payments) {
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
            data: [0, 10, 5, 2, 45, 0]
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

