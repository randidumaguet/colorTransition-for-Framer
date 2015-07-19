# instantiate variables
colors = [
	"rgba(26, 188, 156, 1 )",
	"rgba(230, 126, 34, 1)",
	"rgba(41, 128, 185, 1)",
	"rgba(142, 68, 173, 1)",
	"rgba(44, 62, 80, 1)"
]

ct = ""
transitionCompleted = [ false, false, false, false ]

#instantiate functions
Layer::getColor = ->
	rgbArray = this.backgroundColor.substring( 4 )
	rgbArray = rgbArray.substring( rgbArray.length - 1, 1 ).split( ',' )
	for i in [ 0 .. ( rgbArray.length - 1 ) ]
		rgbArray[i] = parseFloat( rgbArray[i] )
	return rgbArray
		
Layer::colorTransition = ( red, green, blue, alpha ) ->
	initialColor = this.getColor()
	if alpha == undefined || alpha == '' || alpha == null
		alpha = 1
	newColor = [ red, green, blue, alpha ]
	for i in [ 0 .. 3 ]
		initialColor[i] += Math.round( ( newColor[i] - initialColor[i] ) / 6 )
	this.backgroundColor = 'rgba(' + initialColor[0] + ',' + initialColor[1] + ',' + initialColor[2] + ',' + initialColor[3] + ')'
	for j in [ 0 .. 3 ]
		if initialColor[j] > newColor[j]
			if initialColor[j] <= ( newColor[j] + 3 )
				initialColor[j] = newColor[j]
				transitionCompleted[j] = true
		else if initialColor[j] < newColor[j]
			if initialColor[j] >= ( newColor[j] - 3 )
				initialColor[j] = newColor[j]
				transitionCompleted[j] = true
		else if initialColor[j] == newColor[j]
			transitionCompleted[j] = true
	if transitionCompleted[0] == true && transitionCompleted[1] == true && transitionCompleted[2] == true && transitionCompleted[3] == true		
		clearInterval( ct )
		ct = ""
		transitionCompleted = [ false, false, false, false ]

# Create a background
background = new BackgroundLayer
	width: Screen.width
	height: Screen.height
	opacity: 1
	backgroundColor: Utils.randomChoice( colors )

for i of colors
	button = new Layer
		x: ( 100 * i ) + ( 20 * i ) + 80
		y: Screen.height - 180
		opacity: 1
		backgroundColor: colors[i]
		borderRadius: 10
	button.shadowY = 5
	button.shadowBlur = 10
	button.shadowColor = "rgba(0,0,0,0.2)"
	button.style["border"] = "1px solid rgba( 0, 0, 0, 0.1 )"
	button['bgColor'] = colors[i]	
	button.on Events.Click, ->
		rgbArray = this['bgColor'].substring( 4 )
		rgbArray = rgbArray.substring( rgbArray.length - 1, 1 ).split( ',' )
		for i in [ 0 .. ( rgbArray.length - 1 ) ]
			rgbArray[i] = parseFloat( rgbArray[i] )
		ct = setInterval () ->
			background.colorTransition( rgbArray[0], rgbArray[1], rgbArray[2], rgbArray[3] )
		, 20	