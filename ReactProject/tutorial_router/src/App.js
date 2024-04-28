import Header from './Header';
import Nav from './Nav';
import Footer from './Footer';
import Home from './Home';
import NewPost from './NewPost';
import PostPage from './PostPage';
import About from './About';
import Missing from './Missing';
import EditPost from './EditPost';
import { DataProvider } from './context/DataContext';
import { Route, Switch } from 'react-router-dom';


function App() {
  return (
    <div className="App">
      <DataProvider>
        <Header title="React JS Blog" />
        <Nav />
        <Switch>
          <Route exact path="/" component={Home} />
          <Route exact path="/post" component={NewPost} />
          <Route path="/edit/:id" component={EditPost} />
          <Route path="/post/:id" component={PostPage}/>
          <Route path="/about" component={About} />
          <Route path="*" component={Missing} />
        </Switch>
        <Footer />
      </DataProvider>
    </div>
  );
}

export default App;
