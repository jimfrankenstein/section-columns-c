---
---

# basic namespace

window.leadpagesUX ||= {}

# onboarding script

leadpagesUX.sectionColumnControls =

  init: () ->

    @builderScreen = document.querySelector('.builderScreen')


    @bindings()

  bindings: ->

    _t = this

    # help modal triggers
    
    document.querySelector('.startBuildingButton').addEventListener('click', ->
      _t.toggleHelpModal(state = 'closed')
    )

    document.querySelector('.closeHelpModal').addEventListener('click', ->
      _t.toggleHelpModal(state = 'closed')
    )

    document.querySelector('.helpButton').addEventListener('click', ->
      _t.toggleHelpModal(state = 'open')
    )

    # sidebar triggers

    sidebarToggles = @builderScreen.querySelectorAll('.builderSidebar .builderSidebar__toggle')

    [].forEach.call(sidebarToggles, (sidebarToggle) ->
      sidebarToggle.addEventListener('click', ->
        pane = sidebarToggle.dataset.pane
        _t.paneToggle(pane)
      )
    )

    # widget hover

    widgets = @builderScreen.querySelectorAll('.widget')

    [].forEach.call(widgets, (widget) ->
      widget.querySelector('.widget__divider').addEventListener( 'mouseover', (e) ->
        _t.activateWidgetResize(widget)
      )
      widget.querySelector('.widget__divider').addEventListener( 'mouseleave', (e) ->
        _t.deactivateWidgetResize(widget)
      )
    )

    # section sidebar

    @sectionStyles = @builderScreen.querySelectorAll('.sectionStyle')

    [].forEach.call(@sectionStyles, (sectionStyle) ->
      
      # which section is being referenced?
      sectionName = sectionStyle.dataset.section
      section = document.querySelector("#builderSection__#{sectionName}")
      sectionData = section.dataset

      columnStylesContainer = sectionStyle.querySelector('.columnStylesContainer')

      sectionStyle.querySelector('.sectionStyleHead').addEventListener( 'click', (e) ->
        
        # delete section
        
        if e.srcElement.classList.contains('deleteSection')
          if window.confirm('Are you sure you want to delete this section?')
            section.parentNode.removeChild(section)
            sectionStyle.parentNode.removeChild(sectionStyle)
            _t.builderScreen.querySelector('.sectionStylesContainer').classList.remove('section-isOpen')

        # open settings
        
        else
          _t.paneSwapArea = section
          _t.paneSwap(state = 'on', pane = 'section', paneData = sectionData)
      )

      # highlight section

      sectionStyle.querySelector('.sectionStyleHead').addEventListener( 'mouseover', (e) ->
        _t.highlightSectionFromSidebar(section, state = 'on')
      )

      # remove highlight

      sectionStyle.querySelector('.sectionStyleHead').addEventListener( 'mouseleave', (e) ->
        _t.highlightSectionFromSidebar(section, state = 'off')
      )
    )

    # add section

    @builderScreen.querySelector('.addSection').addEventListener( 'click', (e) ->
      _t.addSection()
    )

    # add column
    document.querySelector('.addColumn').addEventListener( 'click', (e) ->
      _t.addColumn()
    )

    # section setting icon triggers

    @sectionTriggers = @builderScreen.querySelectorAll('.sectionTrigger')

    [].forEach.call(@sectionTriggers, (sectionTrigger) ->
      sectionName = sectionTrigger.parentElement.id.split('builderSection__')[1]

      sectionTrigger.addEventListener( 'click', (e) ->
        _t.toggleSectionFromTrigger(sectionName)
      )
    )

    # close settings pane

    closeSettingsPanes = @builderScreen.querySelectorAll('.closeSettingsPane')

    [].forEach.call(closeSettingsPanes, (closeSettingsPane) ->
      closeSettingsPane.addEventListener( 'click', (e) ->
        if closeSettingsPane.parentElement.parentElement.classList.contains('stylesPane__column')
          _t.paneSwap(state = 'on', pane = 'section', paneData = _t.currentSectionData)
        else
          _t.paneSwap(state = 'off')
      )
    )

    # color picker clicks

    colorPickerBubbles = @builderScreen.querySelectorAll('.colorOption')

    [].forEach.call(colorPickerBubbles, (colorPickerBubble) ->
      colorPickerBubble.addEventListener( 'click', (e) ->
        _t.changeAreaColor(bubble = this)
      )
    )

    # toggle option headers

    optionHeaders = @builderScreen.querySelectorAll('.stylesPane__option__name')

    [].forEach.call(optionHeaders, (optionHeader) ->
      option = optionHeader.parentElement
      optionContainer = option.parentElement
      optionHeader.addEventListener( 'click', (e) ->
        _t.toggleOption(option,optionContainer)
      )
    )

    # alignment option clicks

    alignmentOptions = @builderScreen.querySelectorAll('.stylesPane__option--align .stylesPane__option__choice')

    [].forEach.call(alignmentOptions, (alignmentOption) ->
      alignmentOption.addEventListener( 'click', (e) ->
        _t.changeAlignment(alignmentOption)
      )
    )

    # image selector clicks

    imageSelectors = @builderScreen.querySelectorAll('.setting__bgimage')

    [].forEach.call(imageSelectors, (imageSelector) ->
      imageSelector.addEventListener( 'click', (e) ->
        removeClick = e.srcElement.classList.contains('removeimage')
        _t.changeAreaBackgroundImage(imageSelector = this, removeClick)
      )
    )

    # option rotator clicks

    option__rotators = @builderScreen.querySelectorAll('.option__rotator')

    [].forEach.call(option__rotators, (option__rotator) ->
      option__rotator.addEventListener( 'click', (e) ->
        rotator = this
        clickedElement = e.srcElement
        clickedParent = clickedElement.parentElement
        
        if clickedElement.classList.contains('option__rotator--decrease') or clickedParent.classList.contains('option__rotator--decrease')
          _t.decreaseRotator(rotator)
        else if clickedElement.classList.contains('option__rotator--increase') or clickedParent.classList.contains('option__rotator--increase')
          _t.increaseRotator(rotator)
      )
    )

    # styles tab controls

    stylesTabs = @builderScreen.querySelectorAll('.stylesTab')
    stylesPane = @builderScreen.querySelector('.stylesPane__section')
    
    [].forEach.call(stylesTabs, (stylesTab) ->
      stylesTab.addEventListener( 'click', (e) ->
        tab = this.dataset.tab
        stylesPane.classList.remove('sectionSettings-isActive','columns-isActive')
        stylesPane.classList.add("#{tab}-isActive")
      )
    )

  
  # toggle options
  toggleOption: (option,optionContainer) ->

    option.classList.toggle('isOpen')

  
  # column sidebar
  toggleHelpModal: (state) ->

    if state is 'open'
      @builderScreen.classList.add('helpModal-open')
    else
      @builderScreen.classList.remove('helpModal-open')
  

  # column sidebar
  bindColumnStyleFunk: (sectionName) ->

    _t = this

    columnStyles = @builderScreen.querySelectorAll('.columnStyle')

    [].forEach.call(columnStyles, (columnStyle) ->

      section = document.querySelector("#builderSection__#{sectionName}")
      columnStylesContainer = document.querySelector('.columnStylesContainer')

      colNum = columnStyle.dataset.column
      column = section.querySelector(".builderColumn:nth-child(#{colNum})")
      columnData = column.dataset

      columnCore = column.querySelector('.builderColumn__core')

      columnData.innerPt = columnCore.dataset.pt
      columnData.innerPr = columnCore.dataset.pr
      columnData.innerPb = columnCore.dataset.pb
      columnData.innerPl = columnCore.dataset.pl

      # column click
      columnStyle.addEventListener('click', (e) ->

        # delete column
        if e.srcElement.classList.contains('deleteColumn')

          if window.confirm('Are you sure you want to delete this column?')

            if section.querySelectorAll('.builderColumn').length <= 1
              column.parentNode.removeChild(column)
              section.querySelector('.builderRow').innerHTML = (_t.columnMarkup(1))

            else

              column.parentNode.removeChild(column)
              # columnStyle.parentNode.removeChild(columnStyle)


            _t.resetColumnStyles(sectionName)
            _t.bindColumnStyleFunk(sectionName)
            # _t.builderScreen.querySelector('.sectionStylesContainer').classList.remove('section-isOpen')
        
        # toggle column
        else
          _t.paneSwapArea = column
          _t.paneSwap(state = 'on', pane = 'column', paneData = columnData)
      )

      # column hightlight
      columnStyle.addEventListener( 'mouseover', (e) ->
        _t.highlightColumnFromSidebar(column, state = 'on')
      )

      # remove highlight
      columnStyle.addEventListener( 'mouseleave', (e) ->
        _t.highlightColumnFromSidebar(column, state = 'off')
      )
    )

  
  # add section
  addSection: ->
    alert 'Adding sections has been disabled in this prototype.'


  # add column
  addColumn: ->

    _t = this

    sectionName = _t.currentSectionData.id

    section = document.querySelector(".builderSection#builderSection__#{sectionName}")
    columnStylesContainer = document.querySelector('.columnStylesContainer')

    # drop in new column
    currentCols = section.querySelector('.builderRow').innerHTML
    columnNum = section.querySelectorAll('.builderColumn').length

    currentCols += @columnMarkup(columnNum + 1)

    section.querySelector('.builderRow').innerHTML = currentCols

    # drop in new column style
    @resetColumnStyles(sectionName)
    @bindColumnStyleFunk(sectionName)



  # column markup
  columnMarkup: (num) ->
    return "<div
        class='builderColumn'
        data-column='#{num}'
        data-align='center'
        data-bgcolor='null'
        data-bgimage='null'
        data-pt='0'
        data-pr='1'
        data-pb='0'
        data-pl='1'
      >
        <div class='builderColumn__divider'><i class='divider__handle'>drag_handle</i></div>

        <div
          class='builderColumn__core'
          data-pt='0'
          data-pr='0'
          data-pb='0'
          data-pl='0'
        >
          <div class='widgetRow'>
            <div class='widget'>
              <div class='widgetControls'>
                <div class='widgetControls__buttons'>
                  <div class='widgetControl widgetControl__move'><i>move</i></div>
                  <div class='widgetControl widgetControl__delete'><i>delete</i></div>
                </div>
              </div>

              <div class='widget__divider'><i class='divider__handle'>drag_handle</i></div>

              Add Widgets Here
            </div>
          </div>
        </div>
      </div>"

  # column style markup
  columnStyleMarkup: (num) ->
    return "<div class='columnStyle fg' data-column='#{num}'>
        <div class='moveColumn'>
          <i>drag_handle</i>
        </div>
        <h3>Column #{num}</h3>
        <i class='dropdownIndicator'>ellipsis</i>
        <div class='columnStyle__controls'>
          <i class='deleteColumn'>delete</i>
          <i class='openColumnSettings'>settings</i>
        </div>
      </div>"
  


  # reset columns on sidebar and page
  resetColumnStyles: (sectionName) ->

    _t = this

    section = document.querySelector(".builderSection#builderSection__#{sectionName}")
    columnStylesContainer = document.querySelector('.columnStylesContainer')
    core = columnStylesContainer.querySelector('.columnStyle__core')
    
    # count all actual columns in section

    remainingColumns = section.querySelectorAll('.builderColumn')
    numColumns = remainingColumns.length

    # loop through them and add a columnStyle

    currentCore = ""

    [].forEach.call(remainingColumns, (col, i) ->
      col.dataset.column = i + 1
      currentCore += _t.columnStyleMarkup(num = i + 1)
    )

    core.innerHTML = currentCore

    # recount column settings
    remainingStyles = columnStylesContainer.querySelectorAll('.columnStyle')
    numStyles = remainingStyles.length

    columnStylesContainer.classList.remove('col1')
    columnStylesContainer.classList.remove('col6')

    if numColumns <= 1
      columnStylesContainer.classList.add('col1')
    else if numColumns >= 6
      columnStylesContainer.classList.add('col6')
    
    if numColumns <= 0
      _t.addColumn()


  # section setting icon triggers
  toggleSectionFromTrigger: (sectionName) ->

    unless @builderScreen.classList.contains('pageStylesPane-isOpen')
      builderPanes = document.querySelector('.builderPanes')
      builderPanes.classList.add('holdTransition')
      @paneToggle('pageStyles')
      setTimeout ( ->
        builderPanes.classList.remove('holdTransition')
      ), 500

    thisSectionStyle = document.querySelector(".sectionStyle[data-section='#{sectionName}']")
    unless thisSectionStyle.classList.contains('isOpen')
      thisSectionStyle.querySelector('.sectionStyleHead').click()


  # section sidebar
  toggleSectionStyles: (sectionStyle) ->

    # if clicking an open section
    if sectionStyle.classList.contains('isOpen')

      # hide all
      sectionStyle.classList.remove('isOpen')
      @builderScreen.querySelector('.sectionStylesContainer').classList.remove('section-isOpen')
    
    # if clicking a new section
    else

      # close current section(s)
      [].forEach.call(@sectionStyles, (sectionStyle) ->
        sectionStyle.classList.remove('isOpen')
      )

      # open this one
      sectionStyle.classList.add('isOpen')
      @builderScreen.querySelector('.sectionStylesContainer').classList.add('section-isOpen')


  # add/remove section highlights from sidebar
  highlightSectionFromSidebar: (section, state) ->

    if state is 'on'
      # compile section id and highlight
      section.classList.add('highlighted')

    else
      # compile section id and remove highlight
      section.classList.remove('highlighted')


  # add/remove column highlights from sidebar
  highlightColumnFromSidebar: (column, state) ->

    if state is 'on'
      # compile section id and highlight
      column.classList.add('highlighted')

    else
      # compile section id and remove highlight
      column.classList.remove('highlighted')


  # activate widget hover resizing
  activateWidgetResize: (widget) ->
    widget.classList.add('widgetResizeActive--right')
    widget.previousSibling.previousSibling.classList.add('widgetResizeActive--left')


  # deactivate widget hover resizing
  deactivateWidgetResize: (widget) ->
    widget.classList.remove('widgetResizeActive--right')
    widget.previousSibling.previousSibling.classList.remove('widgetResizeActive--left')


  # sidebar pane toggling
  paneToggle: (pane) ->

    _t = this

    # if there is a pane open
    if _t.openPane
      
      # if clicking menu icon
      if pane is "menuIcon"
        _t.lastOpenPane = _t.openPane
        _t.builderScreen.classList.remove('widgetsPane-isOpen','pageStylesPane-isOpen','seoPane-isOpen')
        _t.openPane = null

      # if toggling current menu
      else if pane is _t.openPane
        _t.lastOpenPane = _t.openPane
        _t.builderScreen.classList.remove('widgetsPane-isOpen','pageStylesPane-isOpen','seoPane-isOpen')
        _t.openPane = null

      # otherwise
      else
        _t.lastOpenPane = pane
        _t.builderScreen.classList.remove('widgetsPane-isOpen','pageStylesPane-isOpen','seoPane-isOpen')
        _t.builderScreen.classList.add("#{pane}Pane-isOpen")
        _t.openPane = pane

      _t.paneSwap(state = 'off')


    # if there is no pane open
    else
      
      # if clicking menu icon
      if pane is "menuIcon"
        _t.builderScreen.classList.add("#{_t.lastOpenPane}Pane-isOpen")
        _t.openPane = _t.lastOpenPane

      # if clicking any other button
      else
        _t.builderScreen.classList.add("#{pane}Pane-isOpen")
        _t.openPane = pane


  # sidebar pane swapping
  paneSwap: (state, pane, paneData) ->

    # turn off pane
    if state is 'off'
      @paneSwapArea = null
      document.querySelector('.builderPane__pageStylesPane').classList.remove('settings-isOpen','settings-isOpen--page','settings-isOpen--section','settings-isOpen--column')

    # turn on pane
    else
      @populateSettingsPane[pane](paneData)
      document.querySelector('.builderPane__pageStylesPane').classList.add("settings-isOpen","settings-isOpen--#{pane}")


  # sidebar pane swapping
  populateSettingsPane: {

    # page
    'page': (paneData) ->

      _t = leadpagesUX.sectionColumnControls

      # pane
      pagePane = document.querySelector('.stylesPane__page')

      # add background color
      bgColorArea = pagePane.querySelector('.option--bgcolor')
      _t.toggleBgColor(bgColorArea,color = paneData.bgcolor)

      # add background image
      bgImageArea = pagePane.querySelector('.setting__bgimage')
      _t.toggleBgImage(bgImageArea,image = paneData.bgimage)


    # sections
    'section': (paneData) ->

      _t = leadpagesUX.sectionColumnControls

      _t.currentSectionData = paneData

      # close section pane
      document.querySelector('.builderPane__pageStylesPane').classList.remove("settings-isOpen--column")

      # pane
      sectionsPane = document.querySelector('.stylesPane__section')

      # change title
      header = sectionsPane.querySelector('.stylesPane__head')
      header.querySelector('h1').innerHTML = "\"#{paneData.name}\" Settings"

      # add background color
      bgColorArea = sectionsPane.querySelector('.option--bgcolor')
      _t.toggleBgColor(bgColorArea,color = paneData.bgcolor)

      # add background image
      bgImageArea = sectionsPane.querySelector('.setting__bgimage')
      _t.toggleBgImage(bgImageArea,image = paneData.bgimage)

      # add padding
      spacingArea = sectionsPane.querySelector('.stylesPane__option--spacing')
      spacingData = {
        pt: paneData.pt
        pr: paneData.pr
        pb: paneData.pb
        pl: paneData.pl
      }
      _t.toggleSpacing(spacingArea,spacingData)

      sectionName = paneData.id
      _t.resetColumnStyles(sectionName)
      _t.bindColumnStyleFunk(sectionName)


    # columns
    'column': (paneData) ->

      _t = leadpagesUX.sectionColumnControls

      document.querySelector('.stylesPane__column').dataset = paneData

      # close section pane
      document.querySelector('.builderPane__pageStylesPane').classList.remove("settings-isOpen--section")

      # pane
      columnsPane = document.querySelector('.stylesPane__column')

      # change title
      header = columnsPane.querySelector('.stylesPane__head')
      header.querySelector('h1').innerHTML = "Column #{paneData.column} Settings"

      # add background color
      bgColorArea = columnsPane.querySelector('.option--bgcolor')
      _t.toggleBgColor(bgColorArea,color = paneData.bgcolor)

      # add background image
      bgImageArea = columnsPane.querySelector('.setting__bgimage')
      _t.toggleBgImage(bgImageArea,image = paneData.bgimage)

      # add outer spacing
      spacingArea = columnsPane.querySelector('.stylesPane__option--spacing')
      spacingData = {
        pt: paneData.pt
        pr: paneData.pr
        pb: paneData.pb
        pl: paneData.pl
      }
      _t.toggleSpacing(spacingArea,spacingData)

      # add inner spacing
      innerSpacingArea = columnsPane.querySelector('.stylesPane__option--innerSpacing')
      innerSpacingData = {
        pt: paneData.innerPt
        pr: paneData.innerPr
        pb: paneData.innerPb
        pl: paneData.innerPl
      }
      _t.toggleSpacing(innerSpacingArea,innerSpacingData)

      # add alignment
      alignmentArea = columnsPane.querySelector('.stylesPane__option--align')
      _t.toggleAlignment(alignmentArea, alignment = paneData.align)
  }


  # selected image toggling
  toggleBgImage: (bgImageArea,image) ->

    if image isnt "null" and image isnt null
      bgImageArea.querySelector('span').innerHTML = image
      bgImageArea.classList.remove('noimage')

    else
      bgImageArea.querySelector('span').innerHTML = 'Choose Image'
      bgImageArea.classList.add('noimage')


  # selected color toggling
  toggleBgColor: (bgColorArea,color) ->
    
    bgColorArea.querySelector('.colorOption.active').classList.remove('active') if bgColorArea.querySelector('.colorOption.active')

    if color isnt "null" and color isnt null
      
      bgColorArea.querySelector(".colorOption--#{color}").classList.add('active')
      bgColorArea.classList.remove('nocolor')

    else
      bgColorArea.classList.add('nocolor')


  # spacing toggling
  toggleSpacing: (spacingArea,spacingData) ->

    topRotator = spacingArea.querySelector('.option--topSpacing .option__rotator')
    rightRotator = spacingArea.querySelector('.option--rightSpacing .option__rotator')
    bottomRotator = spacingArea.querySelector('.option--bottomSpacing .option__rotator')
    leftRotator = spacingArea.querySelector('.option--leftSpacing .option__rotator')

    @setSpacingValue(topRotator,spacingData.pt)
    @setSpacingValue(rightRotator,spacingData.pr)
    @setSpacingValue(bottomRotator,spacingData.pb)
    @setSpacingValue(leftRotator,spacingData.pl)


  # spacing toggling
  toggleAlignment: (alignmentArea, alignment) ->

    alignmentArea.querySelector('.stylesPane__option__choice.isActive').classList.remove('isActive') if alignmentArea.querySelector('.stylesPane__option__choice.isActive')
    alignmentArea.querySelector(".stylesPane__option__choice--#{alignment}").classList.add('isActive')

  # spacing toggling
  setSpacingValue: (rotator,val) ->

    # set value data
    rotator.dataset.val = val

    # set rotator value
    rotator.querySelector('.option__rotator--value').innerHTML = val

  # selected background image toggling
  changeAreaBackgroundImage: (bgImageArea, removeClick) ->

    if bgImageArea.classList.contains('noimage')
      newImage = 'bkg.jpg'
      @paneSwapArea.dataset.bgimage = newImage
      @paneSwapArea.style.backgroundImage = "url('../builder-03-section-column-controls/images/#{newImage}')"
      @toggleBgImage(bgImageArea,newImage)

    else if removeClick and window.confirm('Are you sure you want to remove this background image?')
      newImage = 'null'
      @paneSwapArea.dataset.bgimage = null
      @paneSwapArea.style.backgroundImage = "none"
      @toggleBgImage(bgImageArea,newImage)


  # selected color toggling
  changeAreaColor: (bubble) ->
    
    bgColorArea = bubble.parentElement.parentElement
    newColor = bubble.dataset.color

    @toggleBgColor(bgColorArea, newColor)
    @paneSwapArea.dataset.bgcolor = newColor

    insideTheLines = @paneSwapArea
    insideTheLines = @paneSwapArea.querySelector('.builderColumn__core') if @paneSwapArea.classList.contains('builderColumn')

    if bubble.classList.contains('removeColor')
      insideTheLines.style.backgroundColor = "transparent"

    else
      insideTheLines.style.backgroundColor = "##{newColor}"


  # column alignment toggling
  changeAlignment: (alignmentOption) ->
    
    alignmentArea = alignmentOption.parentElement.parentElement
    newAlignment = alignmentOption.dataset.align
    @toggleAlignment(alignmentArea, newAlignment)
    @paneSwapArea.dataset.align = newAlignment


  # spacing toggling
  setSpacingVisuals: (field,val,optionalTarget) ->
    
    if optionalTarget
      @paneSwapArea.querySelector(optionalTarget).dataset[field] = val
    else
      @paneSwapArea.dataset[field] = val


  # decrease rotator value
  decreaseRotator: (rotator) ->
    value = rotator.dataset.val

    unless value <= 0
      newVal = parseInt(rotator.dataset.val,10) - 1
      @setSpacingValue(rotator,newVal)

      field = rotator.dataset.field
      optionalTarget = rotator.dataset.target
      @setSpacingVisuals(field,newVal,optionalTarget)


  # increase rotator value
  increaseRotator: (rotator) ->
    value = rotator.dataset.val

    unless value >= 10
      newVal = parseInt(rotator.dataset.val,10) + 1
      @setSpacingValue(rotator,newVal)

      field = rotator.dataset.field
      optionalTarget = rotator.dataset.target
      @setSpacingVisuals(field,newVal,optionalTarget)

























