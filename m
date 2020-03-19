Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E48FC18AA49
	for <lists+kvm-ppc@lfdr.de>; Thu, 19 Mar 2020 02:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgCSBYX (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 18 Mar 2020 21:24:23 -0400
Received: from smtprelay0117.hostedemail.com ([216.40.44.117]:52480 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726596AbgCSBYX (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 18 Mar 2020 21:24:23 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 246F82C6D;
        Thu, 19 Mar 2020 01:24:22 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:967:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2110:2393:2525:2553:2560:2563:2682:2685:2828:2859:2902:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:7522:7903:9025:10004:10400:10848:11232:11658:11914:12043:12297:12438:12555:12740:12760:12895:12986:13019:13069:13161:13229:13255:13311:13357:13439:14096:14097:14181:14659:14721:21080:21433:21627:21811:21939:30054:30070:30089:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: fork59_8ba5e05ec15f
X-Filterd-Recvd-Size: 1916
Received: from XPS-9350 (unknown [172.58.27.183])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Thu, 19 Mar 2020 01:24:19 +0000 (UTC)
Message-ID: <7584d7937f4bb929beb0b9f5e80523653297676d.camel@perches.com>
Subject: Re: [PATCH -next 016/491] KERNEL VIRTUAL MACHINE FOR POWERPC
 (KVM/powerpc): Use fallthrough;
From:   Joe Perches <joe@perches.com>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date:   Wed, 18 Mar 2020 18:22:29 -0700
In-Reply-To: <20200319011840.GA5033@blackberry>
References: <cover.1583896344.git.joe@perches.com>
         <37a5342c67e1b68b9ad06aca8da245b0ff409692.1583896348.git.joe@perches.com>
         <20200319011840.GA5033@blackberry>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, 2020-03-19 at 12:18 +1100, Paul Mackerras wrote:
> On Tue, Mar 10, 2020 at 09:51:30PM -0700, Joe Perches wrote:
> > Convert the various uses of fallthrough comments to fallthrough;
> > 
> > Done via script
> > Link: https://lore.kernel.org/lkml/b56602fcf79f849e733e7b521bb0e17895d390fa.1582230379.git.joe.com/
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> The subject line should look like "KVM: PPC: Use fallthrough".

There's no way to generate a subject line like that via a script
so far as I can tell.

> Apart from that,
> 
> Acked-by: Paul Mackerras <paulus@ozlabs.org>
> 
> How are these patches going upstream?  Do you want me to take this via
> my tree?

If you want.

Ideally, these changes would go in treewide via a script run
by Linus at an -rc1, but if the change is OK with you, it'd
be fine to have you apply it now.

cheers, Joe



