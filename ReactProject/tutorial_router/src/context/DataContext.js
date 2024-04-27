import { createContext, useState, useEffect} from "react";
import { useHistory } from 'react-router-dom';
import { format } from 'date-fns';
import api from '../api/posts';
import useWindowsSize from '../hooks/useWindowsSize';
import useAxiosFetch from '../hooks/useAxiosFetch';
const DataContext = createContext({});

export const DataProvider = ({ children}) => {
    const [posts, setPosts] = useState([]);
    const [search, setSearch] = useState('');
    const [searchResults, setSearchResults] = useState([]);
    const [postTitle, setPostTitle] = useState('');
    const [postBody, setPostBody] = useState('');
    const [editTitle, setEditTitle] = useState('');
    const [editBody, setEditBody] = useState('');
    const history = useHistory();
    const { width } = useWindowsSize();
  
    const { data, fetchError, isLoading } = useAxiosFetch('http://localhost:3500/posts');
  
    useEffect(() => {
      setPosts(data);
    }, [data])
  
    useEffect(() => {
      const filteredResults = posts.filter(post =>
        ((post.body).toLowerCase()).includes(search.toLowerCase())
        || ((post.title).toLowerCase()).includes(search.toLowerCase()));
  
      setSearchResults(filteredResults.reverse());
    }, [posts, search])

    const handleSubmit = async (e) => {
        e.preventDefault();
        const id = posts.length ? posts[posts.length - 1].id + 1 : 1;
        const datetime = format(new Date(), 'MMMM dd, yyyy pp');
        const newPost = { id, title: postTitle, datetime, body: postBody };
        try {
          const response = await api.post('/posts', newPost);
          const allPosts = [...posts, newPost];
          setPosts(allPosts);
          setPostTitle('');
          setPostBody('');
          history.push('/');
        } catch (err) {
          console.log(`Error: ${err.message}`);
        }
    
      }
    
      const handleDelete = async (id) => {
        try {
          await api.delete(`/posts/${id}`);
          const postsLists = posts.filter(post => post.id !== id);
          setPosts(postsLists);
          history.push('/');
        } catch (err) {
          console.log(`Error: ${err.message}`);
        }
      }
    
      const handleEdit = async (id) => {
        const datetime = format(new Date(), 'MMMM dd, yyyy pp');
        const updatedPost = { id, title: editTitle, datetime, body: editBody };
        try {
          const response = await api.put(`/posts/${id}`, updatedPost);
          setPosts(posts.map(post => post.id === id ? { ...response.data } : post));
          setEditTitle('');
          setEditBody('');
          history.push('/');
        } catch (err) {
          console.log(`Error: ${err.message}`);
        }
      }

    return (
        <DataContext.Provider value={{
            width, search, setSearch,
            searchResults, fetchError, isLoading
        }}>
            {children}
        </DataContext.Provider>
    )
}

export default DataContext;