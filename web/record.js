RecordPlayer.getInstance({
    whiteboardParams: {
        urlArr: [
            '/assets/161047310-206967194175233-1616931204735-0.gz',
            '/assets/161055521-206967194175233-1616931204735-0.gz'
        ],
        container: document.getElementById('wb')
    }
})
.then(({player}) => {
    player.bindControlContainer(document.getElementById('tb'))
})
