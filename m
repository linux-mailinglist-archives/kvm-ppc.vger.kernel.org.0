Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 822AE34F816
	for <lists+kvm-ppc@lfdr.de>; Wed, 31 Mar 2021 06:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbhCaEmQ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 31 Mar 2021 00:42:16 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:42345 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233594AbhCaEl7 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 31 Mar 2021 00:41:59 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4F9DDk40Drz9sVq; Wed, 31 Mar 2021 15:41:58 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1617165718; bh=2EYgyDCXlPOxHbkHJwFitlOfJjafknXZrz2SFyNR4O0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DgEdJAZ7aHWX3BMKfNCiMb/YeXrWTVjoB+7ASYXew2dzJw7aFwLcoMuIIHQuWbHnr
         Z+bOEq8Lclj4J+/l5SYg2r2SSqbS8YaLptHYlrD8TTGVy3ZdIWCy78K1JZZfuI5Ykp
         4lcfte07Xi68uXE9lyylmfygOy5oSDGakIm9fBqMl6K9ILxXwBKA2HspE+c8aaPfBq
         jpOomj4CK+vZKUhSBu9/yLwsGknDrEA1PC/LfFIZKCehonis4SDY5ZXossTI2KVP5+
         jqPI7sl04aXi6Ik7fpIthIG1pHnFoTo3xACGi6jiKnAYPE3VzX8Ly7UmuIoLViTKp6
         VW5wSvBgpQ7Zg==
Date:   Wed, 31 Mar 2021 15:41:54 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: Re: [PATCH v4 08/46] powerpc/64s: Remove KVM handler support from
 CBE_RAS interrupts
Message-ID: <YGP9koHi/bLNYdOp@thinks.paulus.ozlabs.org>
References: <20210323010305.1045293-1-npiggin@gmail.com>
 <20210323010305.1045293-9-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323010305.1045293-9-npiggin@gmail.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Mar 23, 2021 at 11:02:27AM +1000, Nicholas Piggin wrote:
> Cell does not support KVM.
> 
> Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

Acked-by: Paul Mackerras <paulus@ozlabs.org>
