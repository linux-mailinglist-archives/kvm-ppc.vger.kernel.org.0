Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C53D0F3D0
	for <lists+kvm-ppc@lfdr.de>; Tue, 30 Apr 2019 12:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbfD3KL7 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 30 Apr 2019 06:11:59 -0400
Received: from ozlabs.org ([203.11.71.1]:43599 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727199AbfD3KL5 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 30 Apr 2019 06:11:57 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 44tcky33WJz9sCF; Tue, 30 Apr 2019 20:11:54 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1556619114; bh=34P0uHJ0InsGlT8dmZ77ilS67mym5JH+pYFGtRIdUZk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ULb+8uOnALSjtEwqhnaWKfrN5MsnW+vkP4936lAs+cVy6bwOiPIVio6UMP/yfutHi
         7xWLq57JErulIUtC8YEiaiIDgpvGnrhw/C1EQpymCKaIwFpbu+eslICaXQK+Oypo9j
         Tjv7FDcwFgoheFW2WFwc9tJdVBUOs2g8BcpPPjq0B7bu2tmbJHUJxudB5RKhAfAT7g
         2lbfzMA9UfKlqjurHd5ZRuLYusMLMZ4On+9P0id+SCyR9KnR1VJKPwoM+rZxYAk9cN
         ZVlh/fLpZJFBmUsqXKfnL64QpOJ1LltqMsCJGk2dpTwXAQqxmZ07efqwPbLQIJfr93
         mL9H4tkMBuaFQ==
Date:   Tue, 30 Apr 2019 20:01:59 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH kernel] KVM: PPC: Protect memslots while validating user
 address
Message-ID: <20190430100159.GC32205@blackberry>
References: <20190329054113.47864-1-aik@ozlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190329054113.47864-1-aik@ozlabs.ru>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Mar 29, 2019 at 04:41:13PM +1100, Alexey Kardashevskiy wrote:
> Guest physical to user address translation uses KVM memslots and reading
> these requires holding the kvm->srcu lock. However recently introduced
> kvmppc_tce_validate() broke the rule (see the lockdep warning below).
> 
> This moves srcu_read_lock(&vcpu->kvm->srcu) earlier to protect
> kvmppc_tce_validate() as well.
> 
> =============================
> WARNING: suspicious RCU usage
> 5.1.0-rc2-le_nv2_aikATfstn1-p1 #380 Not tainted
> -----------------------------
> include/linux/kvm_host.h:605 suspicious rcu_dereference_check() usage!
> 
> other info that might help us debug this:
> 
> 
> rcu_scheduler_active = 2, debug_locks = 1
> 1 lock held by qemu-system-ppc/8020:
>  #0: 0000000094972fe9 (&vcpu->mutex){+.+.}, at: kvm_vcpu_ioctl+0xdc/0x850 [kvm]
> 
> stack backtrace:
> CPU: 44 PID: 8020 Comm: qemu-system-ppc Not tainted 5.1.0-rc2-le_nv2_aikATfstn1-p1 #380
> Call Trace:
> [c000003fece8f740] [c000000000bcc134] dump_stack+0xe8/0x164 (unreliable)
> [c000003fece8f790] [c000000000181be0] lockdep_rcu_suspicious+0x130/0x170
> [c000003fece8f810] [c0000000000d5f50] kvmppc_tce_to_ua+0x280/0x290
> [c000003fece8f870] [c00800001a7e2c78] kvmppc_tce_validate+0x80/0x1b0 [kvm]
> [c000003fece8f8e0] [c00800001a7e3fac] kvmppc_h_put_tce+0x94/0x3e4 [kvm]
> [c000003fece8f9a0] [c00800001a8baac4] kvmppc_pseries_do_hcall+0x30c/0xce0 [kvm_hv]
> [c000003fece8fa10] [c00800001a8bd89c] kvmppc_vcpu_run_hv+0x694/0xec0 [kvm_hv]
> [c000003fece8fae0] [c00800001a7d95dc] kvmppc_vcpu_run+0x34/0x48 [kvm]
> [c000003fece8fb00] [c00800001a7d56bc] kvm_arch_vcpu_ioctl_run+0x2f4/0x400 [kvm]
> [c000003fece8fb90] [c00800001a7c3618] kvm_vcpu_ioctl+0x460/0x850 [kvm]
> [c000003fece8fd00] [c00000000041c4f4] do_vfs_ioctl+0xe4/0x930
> [c000003fece8fdb0] [c00000000041ce04] ksys_ioctl+0xc4/0x110
> [c000003fece8fe00] [c00000000041ce78] sys_ioctl+0x28/0x80
> [c000003fece8fe20] [c00000000000b5a4] system_call+0x5c/0x70
> 
> Fixes: 42de7b9e2167 ("KVM: PPC: Validate TCEs against preregistered memory page sizes", 2018-09-10)
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

Thanks, patch applied to my kvm-ppc-fixes tree.

Paul.
