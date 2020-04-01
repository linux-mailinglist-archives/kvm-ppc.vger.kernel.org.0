Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC0E19A4A7
	for <lists+kvm-ppc@lfdr.de>; Wed,  1 Apr 2020 07:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731589AbgDAFVf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 1 Apr 2020 01:21:35 -0400
Received: from ozlabs.org ([203.11.71.1]:34861 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbgDAFVf (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 1 Apr 2020 01:21:35 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 48sZLP3qG4z9sSw; Wed,  1 Apr 2020 16:21:33 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1585718493; bh=5Bl1XeuptmLjeySWnIb8rkDfcSw9YFL+/hVx8Zjj+qw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sP9nHm/qJpY+7MJ2GJI/e5s0o4hRBZFdmmiMtz35F8h77oZhDqCay03PKalXx49ga
         nWQML/nRmfAWNRnPcu0JP7gMYGjyzwWOd7nlxreiT3BKiQGBQznoS7Lyw/+E6zcSUR
         b/Giqox51V5hJinO/9IBJ4XNSYrG+ln4wr8JX191QPR7KUskqRdK0+dv0S6Wg8RS1Y
         7wUARHyP+3ty3r3dB90rvSBK45f2RVC5Wko5h/DaTa9M0DTlcHzTW7GYi3STaASbPO
         gu9rURc5/QWdWnxHnBJcEiR3QTDe9Wh/GgsIwA28jg6q0xcMyos9yVyFzDrN4nH7U3
         r7rVS35dqMXGA==
Date:   Wed, 1 Apr 2020 16:21:29 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Cameron Kaiser <spectre@floodgap.com>
Cc:     kvm-ppc@vger.kernel.org
Subject: Re: crash unloading kvm_hv
Message-ID: <20200401052129.GA5599@blackberry>
References: <202004010250.0312o3hp17498362@floodgap.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202004010250.0312o3hp17498362@floodgap.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Mar 31, 2020 at 07:50:03PM -0700, Cameron Kaiser wrote:
> HPT kernel. When removing the kvm_hv module, the kernel goes bananas. Any
> ideas? I had to hard-power-down the machine to get control. I don't have a
> regression range for this.
> 
> # uname -a
> Linux censored.floodgap.com 5.5.10-200.fc31.ppc64le #1 SMP Wed Mar 18 14:11:55 UTC 2020 ppc64le ppc64le ppc64le GNU/Linux
> # lsmod | grep kvm
> kvm_hv                237807  0
> kvm_pr                144641  0
> kvm                   365360  2 kvm_hv,kvm_pr
> # dmesg | grep -i mmu
> [    0.000000] dt-cpu-ftrs: final cpu/mmu features = 0x0001f86f8f5fb1a7 0x3c006041
> [    0.000000] hash-mmu: Page sizes from device-tree:
> [    0.000000] hash-mmu: base_shift=12: shift=12, sllp=0x0000, avpnm=0x00000000, tlbiel=1, penc=0
> [    0.000000] hash-mmu: base_shift=12: shift=16, sllp=0x0000, avpnm=0x00000000, tlbiel=1, penc=7
> [    0.000000] hash-mmu: base_shift=12: shift=24, sllp=0x0000, avpnm=0x00000000, tlbiel=1, penc=56
> [    0.000000] hash-mmu: base_shift=16: shift=16, sllp=0x0110, avpnm=0x00000000, tlbiel=1, penc=1
> [    0.000000] hash-mmu: base_shift=16: shift=24, sllp=0x0110, avpnm=0x00000000, tlbiel=1, penc=8
> [    0.000000] hash-mmu: base_shift=24: shift=24, sllp=0x0100, avpnm=0x00000001, tlbiel=0, penc=0
> [    0.000000] hash-mmu: base_shift=34: shift=34, sllp=0x0120, avpnm=0x000007ff, tlbiel=0, penc=3
> [    0.000000] hash-mmu: Partition table (____ptrval____)
> [    0.000000] hash-mmu: Initializing hash mmu with SLB
> [    0.000000] mmu_features      = 0x7c006001
> [    0.000000] hash-mmu: ppc64_pft_size    = 0x0
> [    0.000000] hash-mmu: htab_hash_mask    = 0x3ffff
> [    0.158070] IOMMU table initialized, virtual merging enabled
> [    0.180907] pci 0000:01:00.0: Adding to iommu group 0
> [    0.180913] pci 0000:01:00.1: Adding to iommu group 0
> [    0.180928] pci 0001:01:00.0: Adding to iommu group 1
> [    0.180942] pci 0003:01:00.0: Adding to iommu group 2
> [    0.180957] pci 0004:01:00.0: Adding to iommu group 3
> [    0.180963] pci 0004:01:00.1: Adding to iommu group 3
> [    0.180978] pci 0005:02:00.0: Adding to iommu group 4
> [    0.180993] pci 0030:01:00.0: Adding to iommu group 5
> [    0.181007] pci 0031:01:00.0: Adding to iommu group 6
> [    0.181021] pci 0033:01:00.0: Adding to iommu group 7
> [    0.449652] iommu: Default domain type: Translated 
> # modprobe -r kvm_hv
> (system becomes unstable)
> 
> Backtrace and dmesg:
> 
> BUG: Kernel NULL pointer dereference on read at 0x00000008
> Faulting instruction address: 0xc00000000088a114
> Oops: Kernel access of bad area, sig: 11 [#1]
> LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA PowerNV
> Modules linked in: kvm_hv(-) kvm_pr kvm xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4 ip6table_mangle ip6table_nat iptable_mangle iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter tun bridge stp llc rfkill sunrpc vmx_crypto at24 regmap_i2c snd_hda_codec_hdmi snd_usb_audio snd_hda_intel snd_intel_dspcfg snd_hda_codec joydev snd_usbmidi_lib snd_rawmidi snd_hda_core mc snd_hwdep snd_seq crct10dif_vpmsum snd_seq_device ofpart snd_pcm ipmi_powernv powernv_flash ipmi_devintf mtd ipmi_msghandler opal_prd rtc_opal snd_timer i2c_opal snd soundcore ip_tables xfs libcrc32c amdgpu mfd_core gpu_sched i2c_algo_bit ttm drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm firewire_ohci firewire_core nvme crc32c_vpmsum tg3 nvme_core crc_itu_t drm_panel_orientation_quirks i2c_core fuse
> CPU: 7 PID: 2268 Comm: modprobe Not tainted 5.5.10-200.fc31.ppc64le #1
> NIP:  c00000000088a114 LR: c00000000088a110 CTR: c000000000529520
> REGS: c0000003dc147970 TRAP: 0300   Not tainted  (5.5.10-200.fc31.ppc64le)
> MSR:  9000000000009033 <SF,HV,EE,ME,IR,DR,RI,LE>  CR: 24008288  XER: 20040000
> CFAR: c00000000000dec4 DAR: 0000000000000008 DSISR: 40000000 IRQMASK: 1 
> GPR00: c00000000088a110 c0000003dc147c00 c000000001e11100 0000000000000000 
> GPR04: 0000000000000000 0000000000000006 0000000000000000 c0000003dac2be00 
> GPR08: 0000000000000000 0000000000000001 0000000080000007 c0080000067019c0 
> GPR12: c000000000529520 c0000003ffff7f00 0000000125c687c0 0000000125c687b8 
> GPR16: 0000000125c687b0 0000000125c687a8 0000000125c68308 0000000000000000 
> GPR20: 0000000125c90068 0000000000000000 00007fffe9aa8c58 00007fffe9aa8c58 
> GPR24: 00000100052d02a0 0000000000000000 00000100052d1db0 00000100052d1e18 
> GPR28: c00000000201a9f0 0000000000000000 c008000006714fd0 0000000000000000 
> NIP [c00000000088a114] percpu_ref_kill_and_confirm+0x44/0x160
> LR [c00000000088a110] percpu_ref_kill_and_confirm+0x40/0x160
> Call Trace:
> [c0000003dc147c00] [c00000000076de6c] selinux_capable+0xbc/0x220 (unreliable)
> [c0000003dc147c80] [c00000000052984c] memunmap_pages+0x32c/0x3f0
> [c0000003dc147d00] [c0080000067002b8] kvmppc_uvmem_free+0x30/0x80 [kvm_hv]
> [c0000003dc147d30] [c0080000066f050c] kvmppc_book3s_exit_hv+0x24/0xc8 [kvm_hv]
> [c0000003dc147d60] [c00000000027c884] sys_delete_module+0x224/0x3b0
> [c0000003dc147e20] [c00000000000b278] system_call+0x5c/0x68

You have kvmppc_uvmem_free in the backtrace.  You probably need either
to apply http://patchwork.ozlabs.org/patch/1258499/ "KVM: PPC: Book3S
HV: Skip kvmppc_uvmem_free if Ultravisor is not supported" or else
turn off CONFIG_PPC_UV.

Paul.
