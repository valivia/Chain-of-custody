import { Controller, Get } from '@nestjs/common';
import { createId } from '@paralleldrive/cuid2';
import * as QRCode from 'qrcode'
import { Public } from "src/guards/auth.guard";

@Controller('util')
export class UtilController {
  constructor() { }

  @Get("scan")
  @Public()
  async showScannable() {
    const id = createId();
    const code = await QRCode.toDataURL(id, { errorCorrectionLevel: 'H', width: 1000 });
    const html = `<img src="${code}" alt="QR Code for ${id}" />`;
    return html;
  }
}
