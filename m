Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C17820EB74
	for <lists+kvm-ppc@lfdr.de>; Tue, 30 Jun 2020 04:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgF3C1U (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 29 Jun 2020 22:27:20 -0400
Received: from ozlabs.org ([203.11.71.1]:48903 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726288AbgF3C1U (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 29 Jun 2020 22:27:20 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 49wpCp1LFCz9sRk; Tue, 30 Jun 2020 12:27:18 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1593484038; bh=NFM6COCoADkJtON3c24Vv6dFmjtqhT4V6y1+lHPgb0g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HAPr1ft04WysSZiADOMjCalamrA2adoBIwdiJ0pp2KzZhZVSmLmTsuGjLjCxYggFr
         q8DiWs7T4bJs329eLGZx7d4U281mnCNHKeyrctNhSGtBnj0cJJj3Wz/N+aRJgkhIRu
         JBgeZ5EjOYIewS9wFaYJPP3pfL/Hf3OlIUuppXCgR/9evzKx+xtCIXquNUwyrChwok
         GH4YJkNpGXJG8FwvzktyPgLLPWFLDU/I3eNGgS0/Hy69HTMtLrxCq+wrcr4PiLe3AF
         GGr0iHUJyQSKRDXJtsbxCJW04BzXYtzeyv0Hdw3MeOCelCh9ZQ3eEpNYjWT7ic5gaB
         xPvLycUUxw1Vw==
Date:   Tue, 30 Jun 2020 12:27:13 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
        Anton Blanchard <anton@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 3/3] powerpc/pseries: Add KVM guest doorbell restrictions
Message-ID: <20200630022713.GA618342@thinks.paulus.ozlabs.org>
References: <20200627150428.2525192-1-npiggin@gmail.com>
 <20200627150428.2525192-4-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200627150428.2525192-4-npiggin@gmail.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sun, Jun 28, 2020 at 01:04:28AM +1000, Nicholas Piggin wrote:
> KVM guests have certain restrictions and performance quirks when
> using doorbells. This patch tests for KVM environment in doorbell
> setup, and optimises IPI performance:
> 
>  - PowerVM guests may now use doorbells even if they are secure.
> 
>  - KVM guests no longer use doorbells if XIVE is available.

It seems, from the fact that you completely remove
kvm_para_available(), that you perhaps haven't tried building with
CONFIG_KVM_GUEST=y.  Somewhat confusingly, that option is not used or
needed when building for a PAPR guest (i.e. the "pseries" platform)
but is used on non-IBM platforms using the "epapr" hypervisor
interface.

If you did intend to remove support for the epapr hypervisor interface
then that should have been talked about in the commit message (and
would I expect be controversial).

So NAK on the kvm_para_available() removal.

Paul.
