Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA15DF3CE
	for <lists+kvm-ppc@lfdr.de>; Tue, 30 Apr 2019 12:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbfD3KL6 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 30 Apr 2019 06:11:58 -0400
Received: from ozlabs.org ([203.11.71.1]:53995 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727196AbfD3KL6 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 30 Apr 2019 06:11:58 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 44tcky2DW3z9sD4; Tue, 30 Apr 2019 20:11:53 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1556619114; bh=qhAXGgMXwflIWvG/zLG2YT+BV0ssmSwr4UlKCnPViKQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hMKT/0Xmw3i7g/s3+deHhu8BVnjyJC5Ovy0eI3ZJS2oXaIoQwhO+HZ7u3ydG8fCLZ
         iZLeRkKTwt5m9qyiknUB8RB4VcFR65gkRc5f/zQiNdyNCYBIE5lLfsxS773zKaAR8/
         lgQLH/Hmbtj3G84bQHNDFQkeplXKvS2Py9JKvsXNHFeJZamkQCCbek3noN5gpO0pAO
         j4WxkYYtuNA89oLK6BCELVsc5RtmXbTzfUWdxS2pGibQSsP9z0n/PWhz0kF50ipaAh
         Q5dyYtU4p3i71VYQobwn3wocYtg/KoPR+Uvbdj10wF6iCMQ+/g0U/SKJ6UoKWrpANk
         /z0mdyWpQ8Iug==
Date:   Tue, 30 Apr 2019 20:00:47 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     David Gibson <david@gibson.dropbear.id.au>, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH kernel] KVM: PPC: Fix lockdep warning when entering the
 guest
Message-ID: <20190430100047.GB32205@blackberry>
References: <20190329054013.47771-1-aik@ozlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190329054013.47771-1-aik@ozlabs.ru>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Mar 29, 2019 at 04:40:13PM +1100, Alexey Kardashevskiy wrote:
> The trace_hardirqs_on() sets current->hardirqs_enabled and from here
> the lockdep assumes interrupts are enabled although they are remain
> disabled until the context switches to the guest. Consequent
> srcu_read_lock() checks the flags in rcu_lock_acquire(), observes
> disabled interrupts and prints a warning (see below).
> 
> This moves trace_hardirqs_on/off closer to __kvmppc_vcore_entry to
> prevent lockdep from being confused.
> 
> DEBUG_LOCKS_WARN_ON(current->hardirqs_enabled)
> WARNING: CPU: 16 PID: 8038 at kernel/locking/lockdep.c:4128 check_flags.part.25+0x224/0x280
> [...]
> NIP [c000000000185b84] check_flags.part.25+0x224/0x280
> LR [c000000000185b80] check_flags.part.25+0x220/0x280
> Call Trace:
> [c000003fec253710] [c000000000185b80] check_flags.part.25+0x220/0x280 (unreliable)
> [c000003fec253780] [c000000000187ea4] lock_acquire+0x94/0x260
> [c000003fec253840] [c00800001a1e9768] kvmppc_run_core+0xa60/0x1ab0 [kvm_hv]
> [c000003fec253a10] [c00800001a1ed944] kvmppc_vcpu_run_hv+0x73c/0xec0 [kvm_hv]
> [c000003fec253ae0] [c00800001a1095dc] kvmppc_vcpu_run+0x34/0x48 [kvm]
> [c000003fec253b00] [c00800001a1056bc] kvm_arch_vcpu_ioctl_run+0x2f4/0x400 [kvm]
> [c000003fec253b90] [c00800001a0f3618] kvm_vcpu_ioctl+0x460/0x850 [kvm]
> [c000003fec253d00] [c00000000041c4f4] do_vfs_ioctl+0xe4/0x930
> [c000003fec253db0] [c00000000041ce04] ksys_ioctl+0xc4/0x110
> [c000003fec253e00] [c00000000041ce78] sys_ioctl+0x28/0x80
> [c000003fec253e20] [c00000000000b5a4] system_call+0x5c/0x70
> Instruction dump:
> 419e0034 3d220004 39291730 81290000 2f890000 409e0020 3c82ffc6 3c62ffc5
> 3884be70 386329c0 4bf6ea71 60000000 <0fe00000> 3c62ffc6 3863be90 4801273d
> irq event stamp: 1025
> hardirqs last  enabled at (1025): [<c00800001a1e9728>] kvmppc_run_core+0xa20/0x1ab0 [kvm_hv]
> hardirqs last disabled at (1024): [<c00800001a1e9358>] kvmppc_run_core+0x650/0x1ab0 [kvm_hv]
> softirqs last  enabled at (0): [<c0000000000f1210>] copy_process.isra.4.part.5+0x5f0/0x1d00
> softirqs last disabled at (0): [<0000000000000000>]           (null)
> ---[ end trace 31180adcc848993e ]---
> possible reason: unannotated irqs-off.
> irq event stamp: 1025
> hardirqs last  enabled at (1025): [<c00800001a1e9728>] kvmppc_run_core+0xa20/0x1ab0 [kvm_hv]
> hardirqs last disabled at (1024): [<c00800001a1e9358>] kvmppc_run_core+0x650/0x1ab0 [kvm_hv]
> softirqs last  enabled at (0): [<c0000000000f1210>] copy_process.isra.4.part.5+0x5f0/0x1d00
> softirqs last disabled at (0): [<0000000000000000>]           (null)
> 
> Fixes: 8b24e69fc47e ("KVM: PPC: Book3S HV: Close race with testing for signals on guest entry", 2017-06-26)
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

Thanks, patch applied to my kvm-ppc-next tree.

Paul.
