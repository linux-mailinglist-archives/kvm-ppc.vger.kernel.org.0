Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADA17B6F45
	for <lists+kvm-ppc@lfdr.de>; Thu, 19 Sep 2019 00:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388402AbfIRWNk (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 18 Sep 2019 18:13:40 -0400
Received: from 7.mo6.mail-out.ovh.net ([46.105.59.196]:33394 "EHLO
        7.mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388401AbfIRWNk (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 18 Sep 2019 18:13:40 -0400
X-Greylist: delayed 4711 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Sep 2019 18:13:39 EDT
Received: from player758.ha.ovh.net (unknown [10.108.57.153])
        by mo6.mail-out.ovh.net (Postfix) with ESMTP id DADA41E153B
        for <kvm-ppc@vger.kernel.org>; Wed, 18 Sep 2019 22:55:06 +0200 (CEST)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net [82.253.208.248])
        (Authenticated sender: groug@kaod.org)
        by player758.ha.ovh.net (Postfix) with ESMTPSA id C6E4AA0042D8;
        Wed, 18 Sep 2019 20:55:00 +0000 (UTC)
Date:   Wed, 18 Sep 2019 22:54:59 +0200
From:   Greg Kurz <groug@kaod.org>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH trivial] KVM: PPC: Remove superfluous check for non-zero
 return value
Message-ID: <20190918225459.0f1091ad@bahia.lan>
In-Reply-To: <20190918184436.5323298d@bahia.lan>
References: <20190911195235.29048-1-thuth@redhat.com>
        <20190918184436.5323298d@bahia.lan>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 11072662635729164594
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedrudekgdduheehucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, 18 Sep 2019 18:44:36 +0200
Greg Kurz <groug@kaod.org> wrote:

> On Wed, 11 Sep 2019 21:52:35 +0200
> Thomas Huth <thuth@redhat.com> wrote:
> 
> > After the kfree()s haven been removed in the previous
> > commit 9798f4ea71ea ("fix rollback when kvmppc_xive_create fails"),
> > the code can be simplified even more to simply always "return ret"
> > now.
> > 
> > Signed-off-by: Thomas Huth <thuth@redhat.com>
> > ---
> 
> This looks like a good candidate for trivial, hence Cc'ing Jiri
> and adding trivial keyword in subject.
> 
> Reviewed-by: Greg Kurz <groug@kaod.org>
> 

Oops, the patch is correct but there are some fixes that require
the return 0 to stay around...

https://patchwork.ozlabs.org/project/kvm-ppc/list/?series=129957

> >  arch/powerpc/kvm/book3s_xive.c        | 5 +----
> >  arch/powerpc/kvm/book3s_xive_native.c | 5 +----
> >  2 files changed, 2 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
> > index e3ba67095895..2f6f463fcdfb 100644
> > --- a/arch/powerpc/kvm/book3s_xive.c
> > +++ b/arch/powerpc/kvm/book3s_xive.c
> > @@ -1986,10 +1986,7 @@ static int kvmppc_xive_create(struct kvm_device *dev, u32 type)
> >  
> >  	xive->single_escalation = xive_native_has_single_escalation();
> >  
> > -	if (ret)
> > -		return ret;
> > -
> > -	return 0;
> > +	return ret;
> >  }
> >  
> >  int kvmppc_xive_debug_show_queues(struct seq_file *m, struct kvm_vcpu *vcpu)
> > diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
> > index a998823f68a3..7a50772f26fe 100644
> > --- a/arch/powerpc/kvm/book3s_xive_native.c
> > +++ b/arch/powerpc/kvm/book3s_xive_native.c
> > @@ -1089,10 +1089,7 @@ static int kvmppc_xive_native_create(struct kvm_device *dev, u32 type)
> >  	xive->single_escalation = xive_native_has_single_escalation();
> >  	xive->ops = &kvmppc_xive_native_ops;
> >  
> > -	if (ret)
> > -		return ret;
> > -
> > -	return 0;
> > +	return ret;
> >  }
> >  
> >  /*
> 

