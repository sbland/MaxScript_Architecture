/*
Glazing System Generator
Version 0.01
By Sam Bland

Glazing System Generator can create a standard glazing system from a spline or Poly

*/

macroScript GlazingSystemGenerator
category:"Architecture"
buttonText:"GS Generator"
tooltip:"GlazingSystemGenerator"
(
		
	local frameMaterial
	local seamMaterial
	local glassMaterial
	
	local horizontals
	local verticals
	local wallHeight
	local frameThickness
	local frameInternalDepth
	local frameExternalDepth
	local glassThickness
	local Frame	
	local GlassObject
	local Seam

	
	fn fnExtrude height= (
		select Frame
		modPanel.addModToSelection (Extrude ()) ui:on
		Frame.modifiers[#Extrude].capStart = off
		Frame.modifiers[#Extrude].capEnd = off
		Frame.modifiers[#Extrude].amount = height
	)

	fn fnAddEdges = (
		modPanel.addModToSelection (Edit_Poly ()) ui:on
		subobjectLevel = 2
			
		if verticals > 0 do(
			$.modifiers[#Edit_Poly].SetSelection #Edge #{}
			$.modifiers[#Edit_Poly].Select #Edge #{1, 3}
			$.modifiers[#Edit_Poly].ButtonOp #SelectEdgeLoop
			$.modifiers[#Edit_Poly].SetOperation #ConnectEdges
			$.modifiers[#Edit_Poly].connectEdgeSegments = verticals
			$.modifiers[#Edit_Poly].connectEdgePinch = 0
			$.modifiers[#Edit_Poly].Commit ()
		)
		if horizontals > 0 do(
			$.modifiers[#Edit_Poly].SetSelection #Edge #{}
			$.modifiers[#Edit_Poly].Select #Edge #{2}
			$.modifiers[#Edit_Poly].ButtonOp #SelectEdgeRing
			$.modifiers[#Edit_Poly].SetOperation #ConnectEdges
			$.modifiers[#Edit_Poly].connectEdgeSegments = horizontals
			$.modifiers[#Edit_Poly].Commit ()
		)
	)

	fn fnCreateSeam = (
		modPanel.addModToSelection (Edit_Poly ()) ui:on
		subobjectLevel = 4
		actionMan.executeAction 0 "40021"
		$.modifiers[#Edit_Poly].SetOperation #Inset
		$.modifiers[#Edit_Poly].insetType = 1
		$.modifiers[#Edit_Poly].insetAmount = (frameThickness/2)
		$.modifiers[#Edit_Poly].Commit ()
		$.modifiers[#Edit_Poly].DetachToObject "SeamSelect"
		Seam = $SeamSelect
		Seam.material = seamMaterial
		subobjectLevel = 0
	)

	fn fnShell inner outer= (
		modPanel.addModToSelection (Shell ()) ui:on
		$.modifiers[#Shell].innerAmount = inner
		$.modifiers[#Shell].outerAmount = outer
	)

	fn fnCreateGlass = ( 
		print "Creating Glass"
		subobjectLevel = 4
		$.insetAmount = 10
		$.EditablePoly.buttonOp #Inset
		modPanel.addModToSelection (Edit_Poly ()) ui:on
		subobjectLevel = 4
		$.modifiers[#Edit_Poly].DetachToObject "GlassSelect"
		GlassObject = $GlassSelect
		GlassObject.material = glassMaterial
		subobjectLevel = 0
	)
	
	fn fnExecute = (
		
		/* set selection as Frame */
		Frame = $	
	Frame.name = "frameSelect" 

	Frame.material = frameMaterial 
		
		if( classof Frame== line) do 
		(
			fnExtrude(wallHeight)		
		)
	

	fnAddEdges ()

	fnCreateSeam()
		
	fnShell frameInternalDepth frameExternalDepth
		
	Frame.name = "Frame"
	/*Close Frame*/


	/* set selection as Seam */
	select Seam

	fnCreateGlass()

	fnShell 10 10

	Seam.name = "Seam"
	/*Close Seam*/


	/* set selection as Glass */
	select GlassObject
	fnShell (glassThickness/2) (glassThickness/2)

	GlassObject.name = "Glass"
	 /*Close Glass*/
		)
		
		
	rollout mainRollout "GlazingSystemGenerator" width:162 height:300
	(
		spinner horizontalsSpinner "horizontals" range: [0, 100, 0]
		spinner verticalsSpinner "verticals" range: [0, 100, 0]
		spinner wallHeightSpinner "wallHeight" range:[0,100000,4000]
		spinner frameThicknessSpinner "frameThickness" range:[0.1,10000,50]
		spinner frameInternalDepthSpinner "frameInternalDepth" range:[0,10000,200]
		spinner frameExternalDepthSpinner "frameExternalDepth" range:[0,10000,50]
		spinner glassThicknessSpinner "glassThickness" range:[0,1000,10]
		
		materialButton frameMaterialBtn "frameMaterial" width:78 height:25			
		materialButton seamMaterialBtn "seamMaterial" width:78 height:25			
		materialButton glassMaterialBtn "glassMaterial" width:78 height:25
					
		on frameMaterialBtn picked mtl do
		(
			frameMaterial = mtl
			print mtl
		)
		on seamMaterialBtn picked mtl do
		(
			seamMaterial = mtl
			print mtl
		)
		on glassMaterialBtn picked mtl do
		(
			glassMaterial = mtl
			print mtl
		)
			
	
					
	
	button splineSelected "Select Spline" width:150 height:20
		on splineSelected pressed do
			(
			
			)
	
	button Start "Start" width:150 height:20
		on Start pressed do
			(
				horizontals = horizontalsSpinner.value
				verticals = verticalsSpinner.value
				wallHeight = wallHeightSpinner.value
				frameThickness = frameThicknessSpinner.value
				frameInternalDepth = frameInternalDepthSpinner.value
				frameExternalDepth = frameExternalDepthSpinner.value
				glassThickness = glassThicknessSpinner.value
							 			
				fnExecute()
			)

)

createdialog mainRollout 
		
	
)

	