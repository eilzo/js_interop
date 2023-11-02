import React from 'react'
import { styled, useTheme } from '@mui/material/styles'
import AppBar from '@mui/material/AppBar'
import Box from '@mui/material/Box'
import Toolbar from '@mui/material/Toolbar'
import Typography from '@mui/material/Typography'
import Button from '@mui/material/Button'
import IconButton from '@mui/material/IconButton'
import MenuIcon from '@mui/icons-material/Menu'
import FlutterFlowLogo from './flutterflow_logo.png'
import GitHubIcon from '@mui/icons-material/GitHub'
import Drawer from '@mui/material/Drawer'
import CssBaseline from '@mui/material/CssBaseline'
import List from '@mui/material/List'
import FormControl from '@mui/material/FormControl'
import MenuItem from '@mui/material/MenuItem'
import InputLabel from '@mui/material/InputLabel'
import Select, { SelectChangeEvent } from '@mui/material/Select'
import TextField from '@mui/material/TextField'
import { FlutterView } from './FlutterView/FlutterView'

const drawerWidth = 300

const Main = styled('main', { shouldForwardProp: (prop) => prop !== 'open' })<{
  open?: boolean;
}>(({ theme, open }) => ({
  display: 'flex',
  justifyContent: 'center',
  alignItems: 'center',
  flexGrow: 1,
  transition: theme.transitions.create('margin', {
    easing: theme.transitions.easing.sharp,
    duration: theme.transitions.duration.leavingScreen,
  }),
  marginLeft: `-${drawerWidth}px`,
  ...(open && {
    transition: theme.transitions.create('margin', {
      easing: theme.transitions.easing.easeOut,
      duration: theme.transitions.duration.enteringScreen,
    }),
    marginLeft: 0,
  }),
}))

const DrawerHeader = styled('div')(({ theme }) => ({
  display: 'flex',
  alignItems: 'center',
  padding: theme.spacing(0, 1),
  // necessary for content to be below app bar
  ...theme.mixins.toolbar,
  justifyContent: 'flex-end',
}))

const FlutterAppWrapper = styled('div')(({ theme }) => ({
  border: '1px solid #eee',
  borderRadius: '5px',
  height: '480px',
  width: '320px',
  transition: theme.transitions.create('all', {
    easing: theme.transitions.easing.easeInOut,
    duration: theme.transitions.duration.enteringScreen,
  }),
  overflow: 'hidden',
}))

const EffectButton = ({ title, toggleClassName }: { title: string, toggleClassName: (name: string) => void }) => {
  const onClick = () => {
    toggleClassName(`fx-${title.toLowerCase()}`)
  }
  return (
    <Button
      variant="outlined"
      onClick={onClick}
      sx={{ minWidth: '130px' }}
    >
      {title}
    </Button>
  )
}

function App () {
  const theme = useTheme()
  const [drawerOpened, setDrawerOpened] = React.useState(false)
  const [classNames, setClassNames] = React.useState('')
  const [color, setColor] = React.useState('blue')
  const [clicks, setClicks] = React.useState(0)
  const [text, setText] = React.useState('')
  const handleDrawer = () => {
    setDrawerOpened(!drawerOpened)
  }
  const toggleClassName = (className: string) => {
    const classNamesArray = classNames.trim().split(/\s+/)
    const index = classNamesArray.indexOf(className)
    if (index === -1) {
      classNamesArray.push(className)
    } else {
      classNamesArray.splice(index, 1)
    }
    setClassNames(classNamesArray.join(' '))
  }
  const handleColorChange = (event: SelectChangeEvent) => {
    setColor(event.target.value as string)
  }
  const handleClicksChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const clicks = parseInt(event.target.value, 10) || 0
    setClicks(clicks)
  }
  const handleTextChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const text = event.target.value || ''
    setText(text)
  }
  const openInNewTab = (url: string) => {
    window.open(url, '_blank', 'noreferrer')
  }
  const parseColor = (color: string) => {
    console.log(color);
    switch(color) {
      case 'blue':
        return '#2096f3';
      case 'red': 
        return '#f44336';
      case 'green':
        return '#1E3A55';
      default:
        return '#4caf51';
    }
  }
  return (
    <Box sx={{ display: 'flex', flexGrow: 1 }}>
      <CssBaseline/>
      <AppBar position="fixed" style={{ background: parseColor(color) }} sx={{ zIndex: (theme) => theme.zIndex.drawer + 1 }}>
        <Toolbar>
          <IconButton
            size="large"
            edge="start"
            color="inherit"
            aria-label="menu"
            onClick={handleDrawer}
            sx={{ mr: 2 }}
          >
            <MenuIcon sx={{ fontSize: 28 }}/>
          </IconButton>
          <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
            React 🤝 FlutterFlow
          </Typography>
          <IconButton
            size="large"
            edge="end"
            color="inherit"
            aria-label="menu"
            onClick={() => openInNewTab('https://github.com/eilzo/js_interop/')}
            sx={{ mr: 1 }}
          >
            <GitHubIcon sx={{ fontSize: 28 }}/>
          </IconButton>
          <IconButton
            size="large"
            edge="end"
            color="inherit"
            aria-label="flutter"
            onClick={() => openInNewTab('https://flutterflow.io')}
          >
            <img src={FlutterFlowLogo} height="48" alt="Logo"/>
          </IconButton>
        </Toolbar>
      </AppBar>
      <Drawer
        open={drawerOpened}
        variant="persistent"
        anchor="left"
        sx={{
          width: drawerWidth,
          flexShrink: 0,
          [`& .MuiDrawer-paper`]: { width: drawerWidth, boxSizing: 'border-box' },
        }}
      >
        <DrawerHeader/>
        <Box sx={{ overflow: 'auto', padding: theme.spacing(1), }}>
          <List>
            <Box>
              <Typography variant="h5" component="h2">Effects</Typography>
              <Box sx={{ display: 'flex', flexGrow: 1, flexWrap: 'wrap', gap: '5px' }}>
                <EffectButton toggleClassName={toggleClassName} title="Shadow"/>
                <EffectButton toggleClassName={toggleClassName} title="Mirror"/>
                <EffectButton toggleClassName={toggleClassName} title="Resize"/>
                <EffectButton toggleClassName={toggleClassName} title="Spin"/>
              </Box>
            </Box>
            <Box mt={2}>
              <Typography variant="h5" component="h2">JS Interop</Typography>
              <FormControl fullWidth>
              
                   <InputLabel id="select-label">Color</InputLabel>
                <Select
                  value={color}
                  label="Color"
                  labelId="select-label"
                  onChange={handleColorChange}
                >
                  <MenuItem value="blue">Blue</MenuItem>
                  <MenuItem value="red">Red</MenuItem>
                  <MenuItem value="green">Green</MenuItem>
                </Select>
                  <TextField
                    label="Text"
                    type="text"
                    value={text}
                    onChange={handleTextChange}
                    InputLabelProps={{
                      shrink: true,
                    }}
                    margin="dense"
                  />
                  <TextField
                    label="Clicks"
                    type="number"
                    value={clicks}
                    onChange={handleClicksChange}
                    InputLabelProps={{
                      shrink: true,
                    }}
                    margin="dense"
                  />
              </FormControl>
            </Box>
          </List>
        </Box>
      </Drawer>
      <Main open={drawerOpened}>
        <FlutterAppWrapper className={classNames}>
          <FlutterView
            assetBase={process.env.PUBLIC_URL + '/flutter/'}
            src={process.env.PUBLIC_URL + '/flutter/main.dart.js'}
            onClicksChange={setClicks}
            onColorChange={setColor}
            onTextChange={setText}
            text={text}
            clicks={clicks}
            color={color}
          />
        </FlutterAppWrapper>
      </Main>
    </Box>
  )
}

export default App