Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC98E1031A0
	for <lists+kvm-ppc@lfdr.de>; Wed, 20 Nov 2019 03:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbfKTCdt (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 19 Nov 2019 21:33:49 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:35133 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727264AbfKTCds (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 19 Nov 2019 21:33:48 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 47HmwB74drz9sPW; Wed, 20 Nov 2019 13:33:46 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1574217226; bh=lv/P09pKDJB1dOVrKwXuQmohaFy+eBFJXd3MEgXRBH0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MOE9brDV/wIAREGaelDw7VlbBoQJT4lxdlTK0nk6lu+uJ2wG+fVKqsMJEfboI6/M8
         b6aJF/MERyiuOA4KXPo5hjILAwgq4njyL3lqvD5jwzlToYWjDb7bWsUOWIsjVGCOnB
         zy4TBJeeJJfifR6iT7kBJrCWV1ESDpMd91VH6SSC94GPsdddcMGFAY1G4pikKr7si1
         WQV7QGMKwhNI2qX2V8bWmtH+tW7USxtDmeGdhlhxdfxMWr8xlE/1R8tOhGLUJ+fEDy
         TFN1hJQ9m7rWgHjxsiFJeIKXjZxMkQ9G1j0NwLWAQFF9c8ByWwZ+63U8cS7aW82n2F
         VeWFMIv/M+GZg==
Date:   Wed, 20 Nov 2019 13:33:34 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     P J P <ppandit@redhat.com>
Cc:     kvm-ppc@vger.kernel.org, Reno Robert <renorobert@gmail.com>,
        P J P <pjp@fedoraproject.org>
Subject: Re: [PATCH v2] kvm: mpic: limit active IRQ sources to NUM_OUTPUTS
Message-ID: <20191120023334.GA24617@oak.ozlabs.ibm.com>
References: <20191115050620.21360-1-ppandit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115050620.21360-1-ppandit@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Nov 15, 2019 at 10:36:20AM +0530, P J P wrote:
> From: P J P <pjp@fedoraproject.org>
> 
> openpic_src_write sets interrupt level 'src->output' masked with
> ILR_INTTGT_MASK(=0xFF). It's then used to index 'dst->outputs_active'
> array. With NUM_OUTPUTS=3, it may lead to OOB array access. Limit
> active IRQ sources to < NUM_OUTPUTS.
> 
> Reported-by: Reno Robert <renorobert@gmail.com>
> Signed-off-by: P J P <pjp@fedoraproject.org>
> ---
>  arch/powerpc/kvm/mpic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Update v2: limit IRQ sources to NUM_OUTPUTS
>   -> https://www.spinics.net/lists/kvm-ppc/msg16554.html
> 
> diff --git a/arch/powerpc/kvm/mpic.c b/arch/powerpc/kvm/mpic.c
> index fe312c160d97..fe4afd54c6e7 100644
> --- a/arch/powerpc/kvm/mpic.c
> +++ b/arch/powerpc/kvm/mpic.c
> @@ -628,7 +628,7 @@ static inline void write_IRQreg_ilr(struct openpic *opp, int n_IRQ,
>  	if (opp->flags & OPENPIC_FLAG_ILR) {
>  		struct irq_source *src = &opp->src[n_IRQ];
> 
> -		src->output = val & ILR_INTTGT_MASK;
> +		src->output = val % NUM_OUTPUTS;

Still not right, I'm afraid, since it could leave src->output set to
3, which would lead to an out-of-bounds array access.  I think it
needs to be

	if (val < NUM_OUTPUTS)
		src->output = val;
	else
		src->output = ILR_INTTGT_INT;

or something like that.

Paul.
