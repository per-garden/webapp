import React, { Component } from 'react'
import logo from './logo.svg'
import './App.css'
import config from './config'

const root_path = config.root_path
const hubs_path = '/api/hubs'
const logout_path = '/api/logout'

class App extends Component {
  constructor(props) {
    super(props)

    // console.log("Yes, I'm inside constructor :-)")
    // var token = window.location.search.split("?api_token=")[1]
    // console.log(token)

    this.state = {
      hubs: [],
      loading: false,
      token: window.location.search.split("?api_token=")[1],
    }
  }

  hubs_index() {
    const that = this
    that.setState({ loading: true })
    that.load(
      'GET',
      root_path + hubs_path,
      {
        api_token: that.state.token,
      },
      function(res) {
        console.log('response from hubs:', res)
        that.setState({ hubs: res, loading: false })
      }
    )
  }

  load(method, url, headers, cb) {
    console.log('---------------')
    console.log(method, url)

    var xhr = new XMLHttpRequest()
    xhr.onreadystatechange = function() {
      if (xhr && xhr.readyState === 4) {

        if (xhr.status === 503) {
          console.log('ERR:', xhr.status)
        }

        if (xhr.status === 200) {
          //console.log('SUCCESS:', xhr.status, xhr.responseText);
        }
        console.log('run cb...' + xhr.readyState)
        cb(JSON.parse(xhr.responseText))
      }
    }

    xhr.open(method, url, true)

    for (var key in headers) {
      console.log('adding header => ', key + ' : ' + headers[key])
      xhr.setRequestHeader(key, headers[key])
    }
    xhr.send()
  }

  logout() {
    const that = this
    that.load(
      'GET',
      root_path + logout_path,
      {
        api_token: that.state.token,
      },
      function(logout_res) {
        console.log('response from logout:', logout_res)
        that.setState({ login: '', password: '', hubs: [], loading: false, token: '',})
      }
    )
    window.location.replace(root_path)
  }

  componentDidMount() { this.hubs_index() }

  render() {
    const state = this.state
    const loading = state.loading
    return (
      <div className="App">
        <header className="App-header">
          {loading && <img src={logo} className="App-logo" alt="logo" />}
          <div>
            <button onClick={this.logout.bind(this)}>LOGOUT</button>
          </div>
        </header>{' '}
        <div>
          {this.state.hubs.map((hub, i) => {
            return <p key={i}> {hub.name + ': ' + hub.id}</p>
          })}
        </div>
      </div>
    )
  }
}

export default App
