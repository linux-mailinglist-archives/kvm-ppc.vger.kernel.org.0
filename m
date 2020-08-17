Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED59246314
	for <lists+kvm-ppc@lfdr.de>; Mon, 17 Aug 2020 11:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgHQJU0 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 17 Aug 2020 05:20:26 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:15267 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgHQJUR (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 17 Aug 2020 05:20:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1597656014;
        s=strato-dkim-0002; d=xenosoft.de;
        h=In-Reply-To:Date:Message-ID:References:Cc:To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=Igq/TLMgvkOXVP7WinmQFpYR30BooBOx4sZndzWkfck=;
        b=p6qI6h0k9B4aOf7vBYfTGNoObvCXKJ/uzxBOizyq8WFu8tFQmFzw3xGgNK/ugn7w4U
        b+r5HgIPenJPhT44mQm5tzkbAj99bi3AsJZ3Zy10uP5qJrsxpMi6D6u50yt9LSRQTIkz
        6mzgmOE/oMvjo4d8raH4bcUGKycGh12MUBhZJhvj0GcLfVE2Wx7ou5ieFNV5SugsU+t0
        C5FuAFY59988XHwEnImHbhmlAPzUGbk/0G6r6ZQTbcMpJESFxoH1RF/T/ZhFLJIhGLEs
        b3NJL4KzT0B2Ymx3hB8s56nsMeQqauYVJDKERnN8OINA1UsNPSXOEcBdKu3SFPpKMoGS
        bqSA==
X-RZG-AUTH: ":L2QefEenb+UdBJSdRCXu93KJ1bmSGnhMdmOod1DhGM4l4Hio94KKxRySfLxnHfJ+Dkjp5DdBJSrwuuqxvPhSI1Vi9hdbute3wuvmUTfEdg9AyQ=="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2a02:8109:89c0:ebfc:15f9:f3ba:c3bc:6875]
        by smtp.strato.de (RZmta 46.10.5 AUTH)
        with ESMTPSA id 60686ew7H9K0n8X
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 17 Aug 2020 11:20:00 +0200 (CEST)
Subject: Re: [Virtual ppce500] virtio_gpu virtio0: swiotlb buffer is full
From:   Christian Zigotzky <chzigotzky@xenosoft.de>
To:     daniel.vetter@ffwll.ch
Cc:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>,
        =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel@daenzer.net>,
        "R.T.Dickinson" <rtd2@xtra.co.nz>,
        Darren Stevens <darren@stevens-zone.net>,
        mad skateman <madskateman@gmail.com>
References: <87h7tb4zwp.fsf@linux.ibm.com>
 <E1C071A5-19D1-4493-B04A-4507A70D7848@xenosoft.de>
 <bc1975fb-23df-09c2-540a-c13b39ad56c5@xenosoft.de>
 <51482c70-1007-1202-9ed1-2d174c1e923f@xenosoft.de>
 <9688335c-d7d0-9eaa-22c6-511e708e0d2a@linux.ibm.com>
 <9805f81d-651d-d1a3-fd05-fb224a8c2031@xenosoft.de>
 <3162da18-462c-72b4-f8f0-eef896c6b162@xenosoft.de>
Message-ID: <3eee8130-6913-49d2-2160-abf0bf17c44e@xenosoft.de>
Date:   Mon, 17 Aug 2020 11:19:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <3162da18-462c-72b4-f8f0-eef896c6b162@xenosoft.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: de-DE
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hello

I compiled the RC1 of kernel 5.9 today. Unfortunately the issue with the 
VirtIO-GPU (see below) still exists. Therefore we still need the patch 
(see below) for using the VirtIO-GPU in a virtual e5500 PPC64 QEMU machine.

Could you please check the first bad commit?

Thanks
Christian


On 12 August 2020 at 3:09 pm, Christian Zigotzky wrote:
> Hello Daniel,
>
> The VirtIO-GPU doesn't work anymore with the latest Git kernel in a 
> virtual e5500 PPC64 QEMU machine [1,2] after the commit "drm/virtio: 
> Call the right shmem helpers". [3]
> The kernel 5.8 works with the VirtIO-GPU in this virtual machine.
>
> I bisected today [4].
>
> Result: drm/virtio: Call the right shmem helpers ( 
> d323bb44e4d23802eb25d13de1f93f2335bd60d0) [3] is the first bad commit.
>
> I was able to revert the first bad commit. [5] After that I compiled a 
> new kernel again. Then I was able to boot Linux with this kernel in a 
> virtual e5500 PPC64 QEMU machine with the VirtIO-GPU.
>
> I created a patch. [6] With this patch I can use the VirtIO-GPU again.
>
> Could you please check the first bad commit?
>
> Thanks,
> Christian
>
> [1] QEMU command: qemu-system-ppc64 -M ppce500 -cpu e5500 -enable-kvm 
> -m 1024 -kernel uImage -drive 
> format=raw,file=fienix-soar_3.0-2020608-net.img,index=0,if=virtio -nic 
> user,model=e1000 -append "rw root=/dev/vda2" -device virtio-vga 
> -device virtio-mouse-pci -device virtio-keyboard-pci -device 
> pci-ohci,id=newusb -device usb-audio,bus=newusb.0 -smp 4
>
> [2] Error messages:
>
> virtio_gpu virtio0: swiotlb buffer is full (sz: 4096 bytes), total 0 
> (slots), used 0 (slots)
> BUG: Kernel NULL pointer dereference on read at 0x00000010
> Faulting instruction address: 0xc0000000000c7324
> Oops: Kernel access of bad area, sig: 11 [#1]
> BE PAGE_SIZE=4K PREEMPT SMP NR_CPUS=4 QEMU e500
> Modules linked in:
> CPU: 2 PID: 1678 Comm: kworker/2:2 Not tainted 
> 5.9-a3_A-EON_X5000-11735-g06a81c1c7db9-dirty #1
> Workqueue: events .virtio_gpu_dequeue_ctrl_func
> NIP:  c0000000000c7324 LR: c0000000000c72e4 CTR: c000000000462930
> REGS: c00000003dba75e0 TRAP: 0300   Not tainted 
> (5.9-a3_A-EON_X5000-11735-g06a81c1c7db9-dirty)
> MSR:  0000000090029000 <CE,EE,ME>  CR: 24002288  XER: 00000000
> DEAR: 0000000000000010 ESR: 0000000000000000 IRQMASK: 0
> GPR00: c0000000000c6188 c00000003dba7870 c0000000017f2300 
> c00000003d893010
> GPR04: 0000000000000000 0000000000000001 0000000000000000 
> 0000000000000000
> GPR08: 0000000000000000 0000000000000000 0000000000000000 
> 7f7f7f7f7f7f7f7f
> GPR12: 0000000024002284 c00000003fff9200 c00000000008c3a0 
> c0000000061566c0
> GPR16: 0000000000000000 0000000000000000 0000000000000000 
> 0000000000000000
> GPR20: 0000000000000000 0000000000000000 0000000000000000 
> 0000000000000000
> GPR24: 0000000000000001 0000000000110000 0000000000000000 
> 0000000000000000
> GPR28: c00000003d893010 0000000000000000 0000000000000000 
> c00000003d893010
> NIP [c0000000000c7324] .dma_direct_unmap_sg+0x4c/0xd8
> LR [c0000000000c72e4] .dma_direct_unmap_sg+0xc/0xd8
> Call Trace:
> [c00000003dba7870] [c00000003dba7950] 0xc00000003dba7950 (unreliable)
> [c00000003dba7920] [c0000000000c6188] .dma_unmap_sg_attrs+0x5c/0x98
> [c00000003dba79d0] [c0000000005cd438] 
> .drm_gem_shmem_free_object+0x98/0xcc
> [c00000003dba7a50] [c0000000006af5b4] 
> .virtio_gpu_cleanup_object+0xc8/0xd4
> [c00000003dba7ad0] [c0000000006ad3bc] .virtio_gpu_cmd_unref_cb+0x1c/0x30
> [c00000003dba7b40] [c0000000006adab8] 
> .virtio_gpu_dequeue_ctrl_func+0x208/0x28c
> [c00000003dba7c10] [c000000000086b70] .process_one_work+0x1a4/0x258
> [c00000003dba7cb0] [c0000000000870f4] .worker_thread+0x214/0x284
> [c00000003dba7d70] [c00000000008c4f0] .kthread+0x150/0x158
> [c00000003dba7e20] [c00000000000082c] .ret_from_kernel_thread+0x58/0x60
> Instruction dump:
> f821ff51 7cb82b78 7cdb3378 4e000000 7cfa3b78 3bc00000 7f9ec000 41fc0014
> 382100b0 81810008 7d808120 48bc1ba8 <e93d0010> ebfc0248 833d0018 7fff4850
> ---[ end trace f28d194d9f0955a8 ]---
>
> virtio_gpu virtio0: swiotlb buffer is full (sz: 4096 bytes), total 0 
> (slots), used 0 (slots)
> virtio_gpu virtio0: swiotlb buffer is full (sz: 16384 bytes), total 0 
> (slots), used 0 (slots)
>
> ---
>
> [3] 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d323bb44e4d23802eb25d13de1f93f2335bd60d0
>
> [4] https://forum.hyperion-entertainment.com/viewtopic.php?p=51377#p51377
>
> [5] git revert d323bb44e4d23802eb25d13de1f93f2335bd60d0 //Output: 
> [master 966950f724e4] Revert "drm/virtio: Call the right shmem 
> helpers" 1 file changed, 1 insertion(+), 1 deletion(-)
>
> [6]
> diff --git a/drivers/gpu/drm/virtio/virtgpu_object.c 
> b/drivers/gpu/drm/virtio/virtgpu_object.c
> index 6ccbd01cd888..346cef5ce251 100644
> --- a/drivers/gpu/drm/virtio/virtgpu_object.c
> +++ b/drivers/gpu/drm/virtio/virtgpu_object.c
> @@ -150,7 +150,7 @@ static int virtio_gpu_object_shmem_init(struct 
> virtio_gpu_device *vgdev,
>      if (ret < 0)
>          return -EINVAL;
>
> -    shmem->pages = drm_gem_shmem_get_pages_sgt(&bo->base.base);
> +    shmem->pages = drm_gem_shmem_get_sg_table(&bo->base.base);
>      if (!shmem->pages) {
>          drm_gem_shmem_unpin(&bo->base.base);
>          return -EINVAL;
> ---

