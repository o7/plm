
function draw_chart(id,calendar,payments) {
    var ctx = document.getElementById(id).getContext('2d');
    new Chart(ctx, {
    type: 'line',
    data: {
        labels: calendar,
        datasets: [
        {
            label: 'Salaries',
            backgroundColor: '#5ca135',
            borderColor: 'green',
            data: [0, 10, 5, 2, 20, 30, 45]
        },
        {
            label: 'Payments',
            backgroundColor: 'SteelBlue',
            borderColor: 'DeepSkyBlue',
            data: [0, 11, 15, 12, 25, 35, 50]
        }
        ]
    },
    options: {}
});

}

