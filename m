Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5B7BFD1B6
	for <lists+kvm-ppc@lfdr.de>; Fri, 15 Nov 2019 00:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbfKNXxy (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 14 Nov 2019 18:53:54 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:52799 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726852AbfKNXxx (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 14 Nov 2019 18:53:53 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 47Ddc005XMz9sPc; Fri, 15 Nov 2019 10:53:51 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1573775632; bh=2V/RXz+xKuYJx9g1fSZQTi6n2RdQziIwtpL/vhI3/KI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NeCT3MIY2bA3YYaeGNA3Ai/L8bYZk+wgCdNRuySG9pMcDSbYrAY95lwXM8TJ9rukr
         HluUo7G6u3rKpXSTn5AGq3olKyOULTNjBWliFdLPFxa6ZriZ1jNSO0NpEjrdaKX0A8
         gKrRTqotTxdaJnz0dcK4OM19p6W/nsokkWYxeO+KoxqJAgr0s18+3ELuPBGyJtHTKN
         uu7SzB5LUrP7IJ34P/01s+4VSIpQFaJpB1XiqmAq687mizZfimf14qKkYrJUTsX9mM
         H8msOUQrIlmmsA5wH1qXliPP3QnQC2cT6aRN0TCMNZwX0S+VUUXDl/Hc+mvwFGSjfl
         L6t4OcohSPvCA==
Date:   Fri, 15 Nov 2019 10:53:49 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     P J P <ppandit@redhat.com>
Cc:     kvm-ppc@vger.kernel.org, Reno Robert <renorobert@gmail.com>,
        P J P <pjp@fedoraproject.org>
Subject: Re: [PATCH] kvm: mpic: extend active IRQ sources to 255
Message-ID: <20191114235349.GA1393@oak.ozlabs.ibm.com>
References: <20191113171208.8509-1-ppandit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113171208.8509-1-ppandit@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Nov 13, 2019 at 10:42:08PM +0530, P J P wrote:
> From: P J P <pjp@fedoraproject.org>
> 
> openpic_src_write sets interrupt level 'src->output' masked with
> ILR_INTTGT_MASK(=0xFF). It's then used to index 'dst->outputs_active'
> array. With NUM_INPUTS=3, it may lead to OOB array access.
> 
> Reported-by: Reno Robert <renorobert@gmail.com>
> Signed-off-by: P J P <pjp@fedoraproject.org>
> ---
>  arch/powerpc/kvm/mpic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kvm/mpic.c b/arch/powerpc/kvm/mpic.c
> index fe312c160d97..a5ae884d3891 100644
> --- a/arch/powerpc/kvm/mpic.c
> +++ b/arch/powerpc/kvm/mpic.c
> @@ -103,7 +103,7 @@ static struct fsl_mpic_info fsl_mpic_42 = {
>  #define ILR_INTTGT_INT    0x00
>  #define ILR_INTTGT_CINT   0x01	/* critical */
>  #define ILR_INTTGT_MCP    0x02	/* machine check */
> -#define NUM_OUTPUTS       3
> +#define NUM_OUTPUTS       0xff

I don't think this is the correct fix.  This code is emulating
hardware which can drive up to three interrupt outputs per CPU, not
255.  Instead we need either to prevent src->output from being set to
3 or greater, or else limit its value when it is used.

Paul.
