Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A675622A8DA
	for <lists+kvm-ppc@lfdr.de>; Thu, 23 Jul 2020 08:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgGWGVV (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 23 Jul 2020 02:21:21 -0400
Received: from ozlabs.org ([203.11.71.1]:50309 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725984AbgGWGVU (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 23 Jul 2020 02:21:20 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4BC2KB4wWlz9sSd; Thu, 23 Jul 2020 16:21:18 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1595485278; bh=hGrvJAeLMwyf4mPSmA682i1yCRFbWUf7OLSrJ5iuVZw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YJwt5yAOjGnlFFYImlzIfZ7VswyXCo8onkCAC47MWHKliIgarhdGtPf5vVhXRdfUT
         CxNVSr1O9bfLS7vm4TYrTx/3gKcaWCr7fbZ9b8jURUbhn1rFSj2cMJyLaqSxfJPoNt
         8cPD2q/zUMf3hEuRlDmlR9URjwyPfUDxwz3Olg0I0cl7Q1SpB2LQgswAtEJjW0Mj4x
         0wV5g3OHn+wBEVmjWWDqzZVAB1wwdOyss/Qp0lzLWmkcY0BbtwwbXGVTmXp+Kd/Nhi
         wf5KbMZrTpbaZ2CxjZYZcz9fM5FqfG3DFOk4DIwAcX+dKWp2RfylqlrDT9b3dEH49a
         6EMA7EpaIbSgg==
Date:   Thu, 23 Jul 2020 16:21:14 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Alistair Popple <alistair@popple.id.au>
Cc:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        mikey@neuling.org, kvm-ppc@vger.kernel.org,
        ravi.bangoria@linux.ibm.com
Subject: Re: [PATCH] powerpc/kvm: Enable support for ISA v3.1 guests
Message-ID: <20200723062114.GF213782@thinks.paulus.ozlabs.org>
References: <20200602055325.6102-1-alistair@popple.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602055325.6102-1-alistair@popple.id.au>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Jun 02, 2020 at 03:53:25PM +1000, Alistair Popple wrote:
> Adds support for emulating ISAv3.1 guests by adding the appropriate PCR
> and FSCR bits.
> 
> Signed-off-by: Alistair Popple <alistair@popple.id.au>

Thanks, patch applied to my kvm-ppc-next branch.

Paul.
