import { Download, Sparkles } from 'lucide-react';

function App() {
  const handleDownload = (fileNumber: number) => {
    const link = document.createElement('a');
    link.href = `/troll-file-${fileNumber}.${fileNumber === 2 ? 'ps1' : 'txt'}`;
    link.download = `important-file-${fileNumber}.${fileNumber === 2 ? 'ps1' : 'txt'}`;
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  return (
    <div className="min-h-screen relative overflow-hidden bg-gradient-to-br from-cyan-500 via-blue-500 to-teal-600">
      <div className="absolute inset-0 bg-[url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNjAiIHZpZXdCb3g9IjAgMCA2MCA2MCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48ZyBmaWxsPSJub25lIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiPjxwYXRoIGQ9Ik0zNiAxOGMzLjMxNCAwIDYgMi42ODYgNiA2cy0yLjY4NiA2LTYgNi02LTIuNjg2LTYtNiAyLjY4Ni02IDYtNnoiIHN0cm9rZT0icmdiYSgyNTUsMjU1LDI1NSwwLjEpIiBzdHJva2Utd2lkdGg9IjIiLz48L2c+PC9zdmc+')] opacity-30"></div>

      <div className="absolute top-10 left-10 w-20 h-20 bg-white/10 rounded-full blur-xl animate-pulse"></div>
      <div className="absolute bottom-20 right-20 w-32 h-32 bg-white/10 rounded-full blur-xl animate-pulse delay-700"></div>
      <div className="absolute top-1/3 right-1/4 w-16 h-16 bg-white/10 rounded-full blur-xl animate-pulse delay-1000"></div>

      <div className="relative z-10 min-h-screen flex flex-col items-center justify-center px-4">
        <div className="text-center mb-12 animate-fade-in">
          <div className="flex items-center justify-center mb-6">
            <Sparkles className="w-16 h-16 text-yellow-300 animate-bounce" />
          </div>
          <h1 className="text-6xl md:text-8xl font-bold text-white mb-4 tracking-tight drop-shadow-2xl">
            Troll Vault
          </h1>
          <p className="text-xl md:text-2xl text-white/90 font-light tracking-wide">
            Qui a laissé son pc déverouillé aujourd'hui ? ^^
          </p>
        </div>

        <div className="flex flex-col md:flex-row gap-6 items-center justify-center">
          <button
            onClick={() => handleDownload(1)}
            className="group relative px-12 py-8 bg-white rounded-2xl shadow-2xl hover:shadow-cyan-500/50 transition-all duration-300 hover:scale-110 hover:-translate-y-2 active:scale-95"
          >
            <div className="absolute inset-0 bg-gradient-to-r from-cyan-400 to-blue-500 rounded-2xl opacity-0 group-hover:opacity-20 transition-opacity duration-300"></div>
            <div className="flex flex-col items-center gap-3">
              <Download className="w-12 h-12 text-cyan-600 group-hover:animate-bounce" />
              <span className="text-2xl font-bold text-gray-800">1 - Activer les scripts</span>
              <span className="text-sm text-gray-500 font-medium">Copier/Coller dans powershell</span>
            </div>
          </button>

          <button
            onClick={() => handleDownload(2)}
            className="group relative px-12 py-8 bg-white rounded-2xl shadow-2xl hover:shadow-teal-500/50 transition-all duration-300 hover:scale-110 hover:-translate-y-2 active:scale-95"
          >
            <div className="absolute inset-0 bg-gradient-to-r from-teal-400 to-green-500 rounded-2xl opacity-0 group-hover:opacity-20 transition-opacity duration-300"></div>
            <div className="flex flex-col items-center gap-3">
              <Download className="w-12 h-12 text-teal-600 group-hover:animate-bounce" />
              <span className="text-2xl font-bold text-gray-800">2 - Fichier de troll</span>
              <span className="text-sm text-gray-500 font-medium">Bim Bam Boum</span>
            </div>
          </button>
        </div>

        <div className="mt-16 text-center">
          <div className="inline-block px-6 py-3 bg-white/20 backdrop-blur-sm rounded-full">
            <p className="text-white/90 text-sm font-medium">
              Created with ❤️ by Alexandre :)
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}

export default App;
