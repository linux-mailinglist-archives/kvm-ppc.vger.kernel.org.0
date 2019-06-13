Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5F6744758
	for <lists+kvm-ppc@lfdr.de>; Thu, 13 Jun 2019 18:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729866AbfFMQ7F (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 13 Jun 2019 12:59:05 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38988 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729859AbfFMAkD (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 12 Jun 2019 20:40:03 -0400
Received: by mail-pf1-f196.google.com with SMTP id j2so10649906pfe.6
        for <kvm-ppc@vger.kernel.org>; Wed, 12 Jun 2019 17:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ajsmv/As4kWp7PFxypjHUQCeoTGmk73dAJL0GI3jbyg=;
        b=czCzDyXT06kRwgZmQwiI2R50jwIomfEc20VgAMeabVKgFfSmcku1JFama0cgMWkQBs
         WPBvcYhGhSCnEIKdwBQzCy1rHdSyNlg9eTKgWdXUekGLKTxe/bAWlsGhGng2mCS6GRkx
         4fCmXOVUOl23wFlm+lo0BX3ItUxyZtcyJWwspxfha4TFi4lDqcgIP2F1mFBRm/14n07a
         FHiTvCtONLQUIhpJ8LnZfy0C8R0jJqYRedY5iZlhy+IahJwXjBpCcxNEdFJWY+4SKorr
         PXOb+70KBGOVhCjA9bYHMBiHZtGnxFXsv/pzs0hVLQQteQuM3pwUrT/onQt8GHLIfhC8
         VFxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ajsmv/As4kWp7PFxypjHUQCeoTGmk73dAJL0GI3jbyg=;
        b=eUKFNG3hH8+lHOti8OU1AKffsvNMuxnO4MNGXyyjUpQOf4OM++QN5JJ3E5fd+eMlRS
         mW8JgbfrvVCJvFgME17y2jk3vCJB2WD7+A4CtDGKdPxQItATr6gO9URiFEHAvjklRQHw
         Hln5545GsTAije0g1/QhjPznsxlDxqHnAxX1+qMtWjZ3m4Yq9vr3PXIIiFsyFQ2IQOXP
         7QoNsj6N8/497P8QJxDrErDcOIjhHl4ZoUFRWA+M69yLWwzrk76KNicshSpS6tev+K2Z
         h3fmIy2hfECd6M/+rxbrRpinmAdhHo1jr3FYuljYPL88VCOu1VPaHJSznpWbQdEvJVcy
         bXdg==
X-Gm-Message-State: APjAAAVSuLh0J9z2jz/1xcQdeNkrLOt3EDEzGOr6lJgL5u6hWe7wUA/e
        L256rcZRw5TTO1gb6MLGOZDKQ55t
X-Google-Smtp-Source: APXvYqx1E1VuHBfVtvmwkN9/TAuRUGltRBx5wekxVd6h84lGsbrtWxpC7X1zySPzj5IXH79ioocGLA==
X-Received: by 2002:a65:5304:: with SMTP id m4mr27293532pgq.126.1560386402968;
        Wed, 12 Jun 2019 17:40:02 -0700 (PDT)
Received: from localhost.localdomain (50-207-200-194-static.hfc.comcastbusiness.net. [50.207.200.194])
        by smtp.googlemail.com with ESMTPSA id s12sm521385pjp.10.2019.06.12.17.40.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 12 Jun 2019 17:40:01 -0700 (PDT)
Message-ID: <1560386385.1924.2.camel@gmail.com>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Fix r3 corruption in h_set_dabr()
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     Michael Neuling <mikey@neuling.org>,
        =?ISO-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
        mpe@ellerman.id.au
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        Suraj Jitindar Singh <surajjs@au1.ibm.com>
Date:   Wed, 12 Jun 2019 17:39:45 -0700
In-Reply-To: <605bc6844ebb0ce2bf9dea906b707359500ceb4f.camel@neuling.org>
References: <20190612072229.15832-1-mikey@neuling.org>
         <c648ec86-8af6-c61f-b430-8e4f7f19225d@kaod.org>
         <605bc6844ebb0ce2bf9dea906b707359500ceb4f.camel@neuling.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.24.6 (3.24.6-1.fc26) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, 2019-06-13 at 10:16 +1000, Michael Neuling wrote:
> On Wed, 2019-06-12 at 09:43 +0200, Cédric Le Goater wrote:
> > On 12/06/2019 09:22, Michael Neuling wrote:
> > > In commit c1fe190c0672 ("powerpc: Add force enable of DAWR on P9
> > > option") I screwed up some assembler and corrupted a pointer in
> > > r3. This resulted in crashes like the below from Cédric:
> > > 
> > >   [   44.374746] BUG: Kernel NULL pointer dereference at
> > > 0x000013bf
> > >   [   44.374848] Faulting instruction address: 0xc00000000010b044
> > >   [   44.374906] Oops: Kernel access of bad area, sig: 11 [#1]
> > >   [   44.374951] LE PAGE_SIZE=64K MMU=Radix MMU=Hash SMP
> > > NR_CPUS=2048 NUMA pSeries
> > >   [   44.375018] Modules linked in: vhost_net vhost tap
> > > xt_CHECKSUM iptable_mangle xt_MASQUERADE iptable_nat nf_nat
> > > xt_conntrack nf_conntrack nf_defrag_ipv6 libcrc32c nf_defrag_ipv4
> > > ipt_REJECT nf_reject_ipv4 xt_tcpudp bridge stp llc ebtable_filter
> > > ebtables ip6table_filter ip6_tables iptable_filter bpfilter
> > > vmx_crypto crct10dif_vpmsum crc32c_vpmsum kvm_hv kvm sch_fq_codel
> > > ip_tables x_tables autofs4 virtio_net net_failover virtio_scsi
> > > failover
> > >   [   44.375401] CPU: 8 PID: 1771 Comm: qemu-system-ppc Kdump:
> > > loaded Not tainted 5.2.0-rc4+ #3
> > >   [   44.375500] NIP:  c00000000010b044 LR: c0080000089dacf4 CTR:
> > > c00000000010aff4
> > >   [   44.375604] REGS: c00000179b397710 TRAP: 0300   Not
> > > tainted  (5.2.0-rc4+)
> > >   [   44.375691] MSR:  800000000280b033
> > > <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 42244842  XER: 00000000
> > >   [   44.375815] CFAR: c00000000010aff8 DAR: 00000000000013bf
> > > DSISR: 42000000 IRQMASK: 0
> > >   [   44.375815] GPR00: c0080000089dd6bc c00000179b3979a0
> > > c008000008a04300 ffffffffffffffff
> > >   [   44.375815] GPR04: 0000000000000000 0000000000000003
> > > 000000002444b05d c0000017f11c45d0
> > >   [   44.375815] GPR08: 078000003e018dfe 0000000000000028
> > > 0000000000000001 0000000000000075
> > >   [   44.375815] GPR12: c00000000010aff4 c000000007ff6300
> > > 0000000000000000 0000000000000000
> > >   [   44.375815] GPR16: 0000000000000000 c0000017f11d0000
> > > 00000000ffffffff c0000017f11ca7a8
> > >   [   44.375815] GPR20: c0000017f11c42ec ffffffffffffffff
> > > 0000000000000000 000000000000000a
> > >   [   44.375815] GPR24: fffffffffffffffc 0000000000000000
> > > c0000017f11c0000 c000000001a77ed8
> > >   [   44.375815] GPR28: c00000179af70000 fffffffffffffffc
> > > c0080000089ff170 c00000179ae88540
> > >   [   44.376673] NIP [c00000000010b044]
> > > kvmppc_h_set_dabr+0x50/0x68
> > >   [   44.376754] LR [c0080000089dacf4]
> > > kvmppc_pseries_do_hcall+0xa3c/0xeb0 [kvm_hv]
> > >   [   44.376849] Call Trace:
> > >   [   44.376886] [c00000179b3979a0] [c0000017f11c0000]
> > > 0xc0000017f11c0000 (unreliable)
> > >   [   44.376982] [c00000179b397a10] [c0080000089dd6bc]
> > > kvmppc_vcpu_run_hv+0x694/0xec0 [kvm_hv]
> > >   [   44.377084] [c00000179b397ae0] [c0080000093f8bcc]
> > > kvmppc_vcpu_run+0x34/0x48 [kvm]
> > >   [   44.377185] [c00000179b397b00] [c0080000093f522c]
> > > kvm_arch_vcpu_ioctl_run+0x2f4/0x400 [kvm]
> > >   [   44.377286] [c00000179b397b90] [c0080000093e3618]
> > > kvm_vcpu_ioctl+0x460/0x850 [kvm]
> > >   [   44.377384] [c00000179b397d00] [c0000000004ba6c4]
> > > do_vfs_ioctl+0xe4/0xb40
> > >   [   44.377464] [c00000179b397db0] [c0000000004bb1e4]
> > > ksys_ioctl+0xc4/0x110
> > >   [   44.377547] [c00000179b397e00] [c0000000004bb258]
> > > sys_ioctl+0x28/0x80
> > >   [   44.377628] [c00000179b397e20] [c00000000000b888]
> > > system_call+0x5c/0x70
> > >   [   44.377712] Instruction dump:
> > >   [   44.377765] 4082fff4 4c00012c 38600000 4e800020 e96280c0
> > > 896b0000 2c2b0000 3860ffff
> > >   [   44.377862] 4d820020 50852e74 508516f6 78840724 <f88313c0>
> > > f8a313c8 7c942ba6 7cbc2ba6
> > > 
> > > This fixes the problem by only changing r3 when we are returning
> > > immediately.
> > > 
> > > Signed-off-by: Michael Neuling <mikey@neuling.org>
> > > Reported-by: Cédric Le Goater <clg@kaod.org>
> > 
> > On nested, I still see : 
> > 
> > [   94.609274] Oops: Exception in kernel mode, sig: 4 [#1]
> > [   94.609432] LE PAGE_SIZE=64K MMU=Radix MMU=Hash SMP NR_CPUS=2048
> > NUMA pSeries
> > [   94.609596] Modules linked in: vhost_net vhost tap xt_CHECKSUM
> > iptable_mangle xt_MASQUERADE iptable_nat nf_nat xt_conntrack
> > nf_conntrack nf_defrag_ipv6 libcrc32c nf_defrag_ipv4 ipt_REJECT
> > nf_reject_ipv4 xt_tcpudp bridge stp llc ebtable_filter ebtables
> > ip6table_filter ip6_tables iptable_filter bpfilter vmx_crypto
> > kvm_hv crct10dif_vpmsum crc32c_vpmsum kvm sch_fq_codel ip_tables
> > x_tables autofs4 virtio_net virtio_scsi net_failover failover
> > [   94.610179] CPU: 12 PID: 2026 Comm: qemu-system-ppc Kdump:
> > loaded Not tainted 5.2.0-rc4+ #6
> > [   94.610290] NIP:  c00000000010b050 LR: c008000008bbacf4 CTR:
> > c00000000010aff4
> > [   94.610400] REGS: c0000017913d7710 TRAP: 0700   Not
> > tainted  (5.2.0-rc4+)
> > [   94.610493] MSR:  800000000284b033
> > <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 42224842  XER: 00000000
> > [   94.610671] CFAR: c00000000010b030 IRQMASK: 0 
> > [   94.610671] GPR00: c008000008bbd6bc c0000017913d79a0
> > c008000008be4300 c000001791376220 
> > [   94.610671] GPR04: 0000000000000000 0000000000000003
> > 00000000f679892e c0000017911045d0 
> > [   94.610671] GPR08: 078000003e018dfe 0000000000000028
> > 0000000000000001 0000000000000075 
> > [   94.610671] GPR12: c00000000010aff4 c000000007ff1300
> > 0000000000000000 0000000000000000 
> > [   94.610671] GPR16: 0000000000000000 c000001791110000
> > 00000000ffffffff c00000179110a7a8 
> > [   94.610671] GPR20: c0000017911042ec ffffffffffffffff
> > 0000000000000000 000000000000000a 
> > [   94.610671] GPR24: fffffffffffffffc 0000000000000000
> > c000001791100000 c000000001a77ed8 
> > [   94.610671] GPR28: c0000017925d0000 fffffffffffffffc
> > c008000008bdf170 c000001791376220 
> > [   94.611818] NIP [c00000000010b050] kvmppc_h_set_dabr+0x5c/0x6c
> > [   94.611932] LR [c008000008bbacf4]
> > kvmppc_pseries_do_hcall+0xa3c/0xeb0 [kvm_hv]
> > [   94.612064] Call Trace:
> > [   94.612115] [c0000017913d79a0] [c000001791100000]
> > 0xc000001791100000 (unreliable)
> > [   94.612252] [c0000017913d7a10] [c008000008bbd6bc]
> > kvmppc_vcpu_run_hv+0x694/0xec0 [kvm_hv]
> > [   94.612394] [c0000017913d7ae0] [c0080000091e8bcc]
> > kvmppc_vcpu_run+0x34/0x48 [kvm]
> > [   94.612536] [c0000017913d7b00] [c0080000091e522c]
> > kvm_arch_vcpu_ioctl_run+0x2f4/0x400 [kvm]
> > [   94.612674] [c0000017913d7b90] [c0080000091d3618]
> > kvm_vcpu_ioctl+0x460/0x850 [kvm]
> > [   94.612821] [c0000017913d7d00] [c0000000004ba6d4]
> > do_vfs_ioctl+0xe4/0xb40
> > [   94.612935] [c0000017913d7db0] [c0000000004bb1f4]
> > ksys_ioctl+0xc4/0x110
> > [   94.613051] [c0000017913d7e00] [c0000000004bb268]
> > sys_ioctl+0x28/0x80
> > [   94.613160] [c0000017913d7e20] [c00000000000b888]
> > system_call+0x5c/0x70
> > [   94.613267] Instruction dump:
> > [   94.613335] 4e800020 e96280c0 896b0000 2c2b0000 4082000c
> > 3860ffff 4e800020 50852e74 
> > [   94.613470] 508516f6 78840724 f88313c0 f8a313c8 <7c942ba6>
> > 7cbc2ba6 38600000 4e800020 
> > 
> > 
> > Here is the asm dump:
> > 
> > 
> > 3:
> >         /* Emulate H_SET_DABR/X on P8 for the sake of compat mode
> > guests */
> >         rlwimi  r5, r4, 5, DAWRX_DR | DAWRX_DW
> > c00000000010b03c:       74 2e 85 50     rlwimi  r5,r4,5,25,26
> >         rlwimi  r5, r4, 2, DAWRX_WT
> > c00000000010b040:       f6 16 85 50     rlwimi  r5,r4,2,27,27
> >         clrrdi  r4, r4, 3
> > c00000000010b044:       24 07 84 78     rldicr  r4,r4,0,60
> >         std     r4, VCPU_DAWR(r3)
> > c00000000010b048:       c0 13 83 f8     std     r4,5056(r3)
> >         std     r5, VCPU_DAWRX(r3)
> > c00000000010b04c:       c8 13 a3 f8     std     r5,5064(r3)
> >         mtspr   SPRN_DAWR, r4
> > c00000000010b050:       a6 2b 94 7c     mtspr   180,r4
> >         mtspr   SPRN_DAWRX, r5
> > c00000000010b054:       a6 2b bc 7c     mtspr   188,r5
> >         li      r3, 0
> > c00000000010b058:       00 00 60 38     li      r3,0
> >         blr
> > c00000000010b05c:       20 00 80 4e     blr
> 
> It's the `mtspr   SPRN_DAWR, r4` as you're HV=0.  I'm not sure how
> nested works
> in that regard. Is the level above suppose to trap and emulate
> that?  
> 

Yeah so as a nested hypervisor we need to avoid that call to mtspr
SPRN_DAWR since it's HV privileged and we run with HV = 0.

The fix will be to check kvmhv_on_pseries() before doing the write. In
fact we should avoid the write any time we call the function from _not_
real mode.

I'll submit a fix for the KVM side. Doesn't look like this is anything
to do with Mikey's patch, was always broken as far as I can tell.

> I'm surprised that's changed by this patch.
> 
> Mikey
> 
> 
> > 
> > C.
> > 
> > 
> > > --
> > > mpe: This is for 5.2 fixes
> > > ---
> > >  arch/powerpc/kvm/book3s_hv_rmhandlers.S | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> > > b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> > > index 139027c62d..f781ee1458 100644
> > > --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> > > +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> > > @@ -2519,8 +2519,10 @@ END_FTR_SECTION_IFSET(CPU_FTR_ARCH_207S)
> > >  	LOAD_REG_ADDR(r11, dawr_force_enable)
> > >  	lbz	r11, 0(r11)
> > >  	cmpdi	r11, 0
> > > +	bne	3f
> > >  	li	r3, H_HARDWARE
> > > -	beqlr
> > > +	blr
> > > +3:
> > >  	/* Emulate H_SET_DABR/X on P8 for the sake of compat
> > > mode guests */
> > >  	rlwimi	r5, r4, 5, DAWRX_DR | DAWRX_DW
> > >  	rlwimi	r5, r4, 2, DAWRX_WT
> > > 
> 
> 
