Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1291211DB0
	for <lists+kvm-ppc@lfdr.de>; Thu,  2 Jul 2020 10:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgGBICZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 2 Jul 2020 04:02:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725954AbgGBICZ (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 2 Jul 2020 04:02:25 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F18C020720;
        Thu,  2 Jul 2020 08:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593676944;
        bh=8rcrbIk2A6kCysFEM6jYq6R6K1UXwo4wFzHsZg1puXA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=08DeUNWGGsuPrcxCNzBfMiY3ALjcfjnUbfwjaEZxYaxefQTYVhC7+ZLyErvI6uh1z
         fQhJ6n7gAliwj7VZe0m2iFcb12ju26foqKPBMq9d2e0DE/vqSFVQHuywrO35vR/OdH
         vjlzzG4nDoPxgwwZjoU+kG0grawkG6LZMZ31zG4w=
Date:   Thu, 2 Jul 2020 09:02:19 +0100
From:   Will Deacon <will@kernel.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Waiman Long <longman@redhat.com>,
        Anton Blanchard <anton@ozlabs.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm-ppc@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 5/8] powerpc/64s: implement queued spinlocks and rwlocks
Message-ID: <20200702080219.GB16113@willie-the-truck>
References: <20200702074839.1057733-1-npiggin@gmail.com>
 <20200702074839.1057733-6-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702074839.1057733-6-npiggin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Jul 02, 2020 at 05:48:36PM +1000, Nicholas Piggin wrote:
> diff --git a/arch/powerpc/include/asm/qspinlock.h b/arch/powerpc/include/asm/qspinlock.h
> new file mode 100644
> index 000000000000..f84da77b6bb7
> --- /dev/null
> +++ b/arch/powerpc/include/asm/qspinlock.h
> @@ -0,0 +1,20 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_POWERPC_QSPINLOCK_H
> +#define _ASM_POWERPC_QSPINLOCK_H
> +
> +#include <asm-generic/qspinlock_types.h>
> +
> +#define _Q_PENDING_LOOPS	(1 << 9) /* not tuned */
> +
> +#define smp_mb__after_spinlock()   smp_mb()
> +
> +static __always_inline int queued_spin_is_locked(struct qspinlock *lock)
> +{
> +	smp_mb();
> +	return atomic_read(&lock->val);
> +}

Why do you need the smp_mb() here?

Will
