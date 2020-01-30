Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 236B014D4E1
	for <lists+kvm-ppc@lfdr.de>; Thu, 30 Jan 2020 01:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbgA3A55 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 29 Jan 2020 19:57:57 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:37907 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726671AbgA3A55 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 29 Jan 2020 19:57:57 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 487MQp6CJpz9sNT; Thu, 30 Jan 2020 11:57:54 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1580345874; bh=5BOdwkogUld+B3olBY9DblXgzaRKNFa9KHpzCLiOwOc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qAqHpCEs3hM7vWm3kqb2jnysnLWs95wpsWnqCdiwwA4l0/HsSQgDbJTcrsAgBVIzB
         rLcYbeMhM6G8RrxiXIIsL70KnRciRr5+o4WsMQlbumY7V1yZif9X022k/MZLpKsdot
         bIZMPf+VODt+fvi0heUtiQAntbUKjpkic+qjdGsqwDMUGI7khbQrd+hS7f9Vulba2A
         cT48R2HAPQxTcequbleAniHR8YcS092PjD+3zyZNDqLBQCbG1Zh5k4icf+Alvqb82u
         OIY3u8G1nhp71tngPYyf8/6itaF6+DmIDE2+b4K3x5v6PVAAMH7LC/SO4FrrjekUpo
         wmi7P0Ev2lTQQ==
Date:   Thu, 30 Jan 2020 11:57:50 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     David Michael <fedora.dm0@gmail.com>
Cc:     kvm-ppc@vger.kernel.org
Subject: Re: [PATCH] KVM: PPC: Book3S PR: Fix -Werror=return-type build
 failure
Message-ID: <20200130005750.GC25802@blackberry>
References: <87v9oxkfxd.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v9oxkfxd.fsf@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sun, Jan 26, 2020 at 05:31:58PM -0500, David Michael wrote:
> Signed-off-by: David Michael <fedora.dm0@gmail.com>
> ---
> 
> Hi,
> 
> I attempted to build 5.4.15 for PPC with KVM enabled using GCC 9.2.0 (on
> Gentoo), and compilation fails due to no return statement in a non-void
> function.
> 
> Can this fix be applied?

Thanks, patch applied to my kvm-ppc-next branch.

Paul.
