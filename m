Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9313F1045EE
	for <lists+kvm-ppc@lfdr.de>; Wed, 20 Nov 2019 22:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbfKTVlZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 20 Nov 2019 16:41:25 -0500
Received: from ozlabs.org ([203.11.71.1]:50449 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725819AbfKTVlZ (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 20 Nov 2019 16:41:25 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 47JGNL4R52z9sPL; Thu, 21 Nov 2019 08:41:22 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1574286082; bh=li28Y2sth80VfkG4EiuioZVPlrdAcRu4bfanliPF3AA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vghJJ6xWEvBviZ86HqyMMrdijKDTbzNLi3bqNoUtS2d9XG0brpg3r20IIk8pz+azd
         TlyaY5Bax0D7Qoq7fBo6FAUvZYn5AZX3yN6MyRV3SHWR2DCngrBcw4FhOyCSyTbsLr
         5LbVqBuA05TWVjDhL6sW90ywLKg0je/YmucQowbX6ESguC+v67Uqu362f+cFttc1sn
         V6fYPPJexnlF9/kq9gULZn9Pm7m7oxWwVJ0tQZPTej1vXKE8RTGWwlQ30iQ0LhcjVO
         AKTmahLeqZg+W1yrrF41q2wvJz10wE4k+QBnmx+vsYKyNYu9J+FdC+Wmub183XfOV3
         8v8bpP+4ZoGkw==
Date:   Thu, 21 Nov 2019 08:41:19 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     P J P <ppandit@redhat.com>
Cc:     kvm-ppc@vger.kernel.org, Reno Robert <renorobert@gmail.com>
Subject: Re: [PATCH v2] kvm: mpic: limit active IRQ sources to NUM_OUTPUTS
Message-ID: <20191120214119.GA12722@blackberry>
References: <20191115050620.21360-1-ppandit@redhat.com>
 <20191120023334.GA24617@oak.ozlabs.ibm.com>
 <nycvar.YSQ.7.76.1911201625080.24911@xnncv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nycvar.YSQ.7.76.1911201625080.24911@xnncv>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Nov 20, 2019 at 04:30:32PM +0530, P J P wrote:
> +-- On Wed, 20 Nov 2019, Paul Mackerras wrote --+
> | Still not right, I'm afraid, since it could leave src->output set to
> | 3, which would lead to an out-of-bounds array access.  I think it
> | needs to be
> 
> ===
> #include <stdio.h>
> 
> int
> main (int argc, char *argv[])
> {   
>     int i = 0;
> 
>     for (i = 0; i < 1024; i++) {
>         printf ("%d: %d\n", i, i % 0x3);
>     }
> 
>     return 0;
> }
> 
> -> https://paste.centos.org/view/fb14b3cf
> ===
> 
> It does not seem to set it to 0x3. When a no is divisible by 0x3, 
> 'src->output' will be set to zero(0).

You're right, I misread the '%' as '&'.

Paul.
