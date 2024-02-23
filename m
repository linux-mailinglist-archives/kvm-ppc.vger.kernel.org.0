Return-Path: <kvm-ppc+bounces-57-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B53CF861F2B
	for <lists+kvm-ppc@lfdr.de>; Fri, 23 Feb 2024 22:43:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7A401C2390F
	for <lists+kvm-ppc@lfdr.de>; Fri, 23 Feb 2024 21:43:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C830E14AD1C;
	Fri, 23 Feb 2024 21:42:56 +0000 (UTC)
X-Original-To: kvm-ppc@vger.kernel.org
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C455F1482FF
	for <kvm-ppc@vger.kernel.org>; Fri, 23 Feb 2024 21:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.228.1.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708724576; cv=none; b=d+mxtGMBuum0j+L68Dyegmy+q2oy6HLMxIfQq71dDHV/m3dqfEWOwtp9iljMnQfKQe4y6A8E2toQiDGuJX2rJ4SMdn+EDSz66RLA4Wc+Nmf7lwweuIlnZWPYQCIREl8Jp4zIp4u8+V5rgg2j3gppur1qjj/PPpF+zy1L+5IbrsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708724576; c=relaxed/simple;
	bh=FF0CFHD5WslkPTmJy2KywnwhSFJibrFQvXVxl4LJJCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Mime-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KDYTKb2CBJIuZQoG6qbfXJzzjmz3O5yJqfi15SdpiXteKgsYvLJc6Ts6n2QKTU3BjrSxF+aGoI0TQDxgstz36trikIFcpgBTULD/wdCg5ODEivUzHTXBeWcXuyjyOiwU4nlU2AkVUHRpPKHS3Ruv3TqU6aEE30I+f+nzVEgfzOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org; spf=pass smtp.mailfrom=kernel.crashing.org; arc=none smtp.client-ip=63.228.1.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.crashing.org
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
	by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 41NKvP9Y021329;
	Fri, 23 Feb 2024 14:57:25 -0600
Received: (from segher@localhost)
	by gate.crashing.org (8.14.1/8.14.1/Submit) id 41NKvNCG021328;
	Fri, 23 Feb 2024 14:57:23 -0600
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date: Fri, 23 Feb 2024 14:57:23 -0600
From: Segher Boessenkool <segher@kernel.crashing.org>
To: Kautuk Consul <kconsul@linux.vnet.ibm.com>
Cc: Thomas Huth <thuth@redhat.com>, aik@ozlabs.ru, groug@kaod.org,
        slof@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH v2] slof/engine.in: refine +COMP and -COMP by not using COMPILE
Message-ID: <20240223205723.GO19790@gate.crashing.org>
References: <20240202051548.877087-1-kconsul@linux.vnet.ibm.com> <Zcnkzks7D0eHVYZQ@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zcnkzks7D0eHVYZQ@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
User-Agent: Mutt/1.4.2.3i

On Mon, Feb 12, 2024 at 02:58:46PM +0530, Kautuk Consul wrote:
> Hi Segher/Thomas,
> 
> On 2024-02-02 00:15:48, Kautuk Consul wrote:
> > Use the standard "DOTICK <word> COMPILE," mechanism in +COMP and -COMP
> > as is being used by the rest of the compiler.
> > Also use "SEMICOLON" instead of "EXIT" to compile into HERE in -COMP
> > as that is more informative as it mirrors the way the col() macro defines
> > a colon definition.
> > 
> > Signed-off-by: Kautuk Consul <kconsul@linux.vnet.ibm.com>
> > ---
> >  slof/engine.in | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/slof/engine.in b/slof/engine.in
> > index 59e82f1..fa4d82e 100644
> > --- a/slof/engine.in
> > +++ b/slof/engine.in
> > @@ -422,8 +422,8 @@ imm(.( LIT(')') PARSE TYPE)
> >  col(COMPILE R> CELL+ DUP @ COMPILE, >R)
> > 
> >  var(THERE 0)
> > -col(+COMP STATE @ 1 STATE +! 0BRANCH(1) EXIT HERE THERE ! COMP-BUFFER DOTO HERE COMPILE DOCOL)
> > -col(-COMP -1 STATE +! STATE @ 0BRANCH(1) EXIT COMPILE EXIT THERE @ DOTO HERE COMP-BUFFER EXECUTE)
> > +col(+COMP STATE @ 1 STATE +! 0BRANCH(1) EXIT HERE THERE ! COMP-BUFFER DOTO HERE DOTICK DOCOL COMPILE,)
> > +col(-COMP -1 STATE +! STATE @ 0BRANCH(1) EXIT DOTICK SEMICOLON COMPILE, THERE @ DOTO HERE COMP-BUFFER EXECUTE)
> 
> What do you think about the above changes ?
> Are there any more changes I could do to this patch ?
> Or if you want to reject can you tell me why exactly ?

I think both changes are bad.  They reduce abstraction, for no reason at
all.

If you think the compiler should inline more, or do better optimisations
even, work on *that*, don't do one unimportant case of it manually.

I never made the indirect threading engine in Paflof faster, because it
was plenty fast already.  In SLOF, almost everything is compiled at
runtime, and if it is important to speed that up there are some well-
known usual caching tricks to make things *factors* faster.  The main
focus points for SLOF were to have an engine that is easily adapted for
different purposes (and it was! Ask me about it :-) ), and to have
things using it as debuggable as possible (you really need some hardware
debugging thing to make it real easy; I had one back then.  You need to
be able to look at all memory state after a stop (a crash, perhaps), and
seeing all CPU registers is useful as well.

If you want to improve engine.in, get rid of it completely?  Make the
whol thing cross-compile perhaps.  Everything from source code.  The
engine.in thing is essentially an already compiled thing (but not
relocated yet, not fixed to some address), which is still in mostly
obvious 1-1 correspondence to it source code, which can be easily
"uncompiled" as well.  Like:

col(+COMP STATE @ 1 STATE +! 0BRANCH(1) EXIT HERE THERE ! COMP-BUFFER DOTO HERE COMPILE DOCOL)
col(-COMP -1 STATE +! STATE @ 0BRANCH(1) EXIT COMPILE EXIT THERE @ DOTO HERE COMP-BUFFER EXECUTE)

: +comp  ( -- )
  state @  1 state +!  IF exit THEN
  here there !
  comp-buffer to here
  compile docol ;
: -comp ( -- )
  -1 state +!
  state @ IF exit THEN
  compile exit
  there @ to here
  comp-buffer execute ;

"['] semicolon compile," is not something a user would ever write.  A
user would write "compile exit".  It is standard Forth, it works
anywhere.  It is much more idiomatic..


Segher

