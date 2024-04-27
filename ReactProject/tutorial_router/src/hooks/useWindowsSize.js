import {useState, useEffect} from 'react';

const useWindowsSize = () => {
    const [windowSize,setWindowsSize] = useState({
        width: undefined,
        height: undefined
    });

    useEffect(() => {

        const handleResize = () => {
            setWindowsSize({
                width: windowSize.innerWidth,
                height: window.innerHeight
            });
        }

        handleResize(); 

        window.addEventListener("resize", handleResize);

        return () => window.removeEventListener("resize", handleResize);
    }, [])

    return windowSize;
}

export default useWindowsSize