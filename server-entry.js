import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import path from 'path';
import { fileURLToPath } from 'url';
import backupRoutes from './routes/backup.js';
import kugouRoutes from './routes/kugou.js';

const app = express();
const PORT = process.env.PORT || 6522;
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// 信任代理（如果需要）
app.set('trust proxy', true);

// CORS 配置
app.use(cors({ origin: true, credentials: true }));
app.use(express.json({ limit: '50mb' }));

// API 路由
app.use('/api/backup', backupRoutes);
app.use('', kugouRoutes);

// 托管前端静态文件（Vue 构建后的 dist 目录）
app.use(express.static(path.join(__dirname, '../dist')));
// 前端路由 fallback（history 模式）
app.get('*', (req, res, next) => {
  if (req.path.startsWith('/api/') || req.path.startsWith('/login/') || req.path.startsWith('/user/') || req.path.startsWith('/playlist/')) {
    return next();
  }
  res.sendFile(path.join(__dirname, '../dist/index.html'));
});

app.listen(PORT, () => {
  console.log(`🚀 copyKgSong 服务运行在 http://localhost:${PORT}`);
});
