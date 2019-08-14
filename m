Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A50A8D12E
	for <lists+kvm-ppc@lfdr.de>; Wed, 14 Aug 2019 12:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbfHNKqV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm-ppc@lfdr.de>); Wed, 14 Aug 2019 06:46:21 -0400
Received: from ozlabs.org ([203.11.71.1]:58131 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727924AbfHNKqU (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 14 Aug 2019 06:46:20 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 467mTj4qzZz9sNC;
        Wed, 14 Aug 2019 20:46:17 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Claudio Carvalho <cclaudio@linux.ibm.com>, linuxppc-dev@ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thiago Bauermann <bauerman@linux.ibm.com>,
        Claudio Carvalho <cclaudio@linux.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>,
        Guerney Hunt <gdhh@linux.ibm.com>
Subject: Re: [PATCH v5 2/7] powerpc/kernel: Add ucall_norets() ultravisor call handler
In-Reply-To: <20190808040555.2371-3-cclaudio@linux.ibm.com>
References: <20190808040555.2371-1-cclaudio@linux.ibm.com> <20190808040555.2371-3-cclaudio@linux.ibm.com>
Date:   Wed, 14 Aug 2019 20:46:15 +1000
Message-ID: <87wofgqb2g.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Claudio Carvalho <cclaudio@linux.ibm.com> writes:
> diff --git a/arch/powerpc/kernel/ucall.S b/arch/powerpc/kernel/ucall.S
> new file mode 100644
> index 000000000000..de9133e45d21
> --- /dev/null
> +++ b/arch/powerpc/kernel/ucall.S
> @@ -0,0 +1,20 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Generic code to perform an ultravisor call.
> + *
> + * Copyright 2019, IBM Corporation.
> + *
> + */
> +#include <asm/ppc_asm.h>
> +#include <asm/export.h>
> +
> +_GLOBAL(ucall_norets)
> +EXPORT_SYMBOL_GPL(ucall_norets)
> +	mfcr	r0
> +	stw	r0,8(r1)
> +
> +	sc	2		/* Invoke the ultravisor */
> +
> +	lwz	r0,8(r1)
> +	mtcrf	0xff,r0
> +	blr			/* Return r3 = status */

Paulus points that we shouldn't need to save CR here. Our caller will
have already saved it if it needed to, and we don't use CR in this
function so we don't need to save it.

That's assuming the Ultravisor follows the hcall ABI in which CR2-4 are
non-volatile (PAPR § 14.5.3).

I know plpar_hcall_norets() does save CR, but it shouldn't need to, that
seems to be historical. aka. no one knows why it does it but it always
has.

cheers
