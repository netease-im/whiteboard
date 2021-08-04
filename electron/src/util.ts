export const insertScript = (url: string) => {
    return new Promise<void>((res, rej) => {
        const script = document.createElement('script');
        script.type = 'text/javascript';
        script.async = true;
        script.onload = function(){
            // remote script has loaded
            res()
        };
        script.onerror = function(err) {
            rej(err)
        }
        
        script.src = url
        document.getElementsByTagName('head')[0].appendChild(script);
    })
}