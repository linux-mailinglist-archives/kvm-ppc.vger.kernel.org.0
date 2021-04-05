Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 761943541EC
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 14:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237081AbhDEMDx (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 5 Apr 2021 08:03:53 -0400
Received: from pv50p00im-ztdg10021201.me.com ([17.58.6.45]:44423 "EHLO
        pv50p00im-ztdg10021201.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237120AbhDEMDx (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 5 Apr 2021 08:03:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=me.com; s=1a1hai;
        t=1617624216; bh=zbF4bJv+okmaRpcsURN+JW+pNyKoocTcBKUgS4a18Hc=;
        h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To;
        b=PmeIf0GME7jJepzAtJJYVKd0Ht5dVlxqCQv4+KijQIqPhULu47rZJkCh0oO/BrQRa
         WWFV77wGsaS8HOdo+p8I3YsYJK7XuM5ElI0++uELcya9AFfT9vDyrjHqaU/nJNM7c3
         BIdJEMd6Ze+fOt6lgP5guE2Ia4YEtoULln0p/1J1kh7lOeDSOo+7vBlw1qZ++Sl7dg
         W4PuGmUxT5f9sx17hQq9Uu4SfbN4DJVIm3h1aip0gJnTmKCmi1CKUSeLTVWR8VasRV
         PYH1M6saouboGal6oSRlFjRl6mX6z3z3ukxluB99xR6A4y/7vi38KkFcstR3lBR4/D
         jiZ0zO3rYwNQA==
Received: from 192.168.1.3 (unknown [120.245.2.39])
        by pv50p00im-ztdg10021201.me.com (Postfix) with ESMTPSA id 5CAFEA401FF;
        Mon,  5 Apr 2021 12:03:28 +0000 (UTC)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH v2] powerpc/traps: Enhance readability for trap types
From:   Xiongwei Song <sxwjean@me.com>
In-Reply-To: <20210401161131.GE13863@gate.crashing.org>
Date:   Mon, 5 Apr 2021 20:03:25 +0800
Cc:     Xiongwei Song <sxwjean@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        benh@kernel.crashing.org, paulus@samba.org, oleg@redhat.com,
        npiggin@gmail.com, Christophe Leroy <christophe.leroy@csgroup.eu>,
        msuchanek@suse.de, aneesh.kumar@linux.ibm.com,
        ravi.bangoria@linux.ibm.com, mikey@neuling.org,
        haren@linux.ibm.com, alistair@popple.id.au, jniethe5@gmail.com,
        peterz@infradead.org, leobras.c@gmail.com,
        akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com,
        atrajeev@linux.vnet.ibm.com, maddy@linux.ibm.com,
        kjain@linux.ibm.com, kan.liang@linux.intel.com, aik@ozlabs.ru,
        pmladek@suse.com, john.ogness@linutronix.de,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <DC60E115-166B-47AC-ACEE-7FEBB48AF5E6@me.com>
References: <20210330150425.10145-1-sxwjean@me.com>
 <875z17y79i.fsf@mpe.ellerman.id.au>
 <20210331212550.GD13863@gate.crashing.org>
 <CAEVVKH8XDiEGHjXj6sJAHynhwqKWpNqj_Ws03AqwNjR8OmHf5w@mail.gmail.com>
 <20210401161131.GE13863@gate.crashing.org>
To:     Segher Boessenkool <segher@kernel.crashing.org>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-05_08:2021-04-01,2021-04-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011 mlxscore=0
 mlxlogscore=921 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2104050083
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


> On Apr 2, 2021, at 12:11 AM, Segher Boessenkool =
<segher@kernel.crashing.org> wrote:
>=20
> On Thu, Apr 01, 2021 at 10:55:58AM +0800, Xiongwei Song wrote:
>> Segher Boessenkool <segher@kernel.crashing.org> =
=E4=BA=8E2021=E5=B9=B44=E6=9C=881=E6=97=A5=E5=91=A8=E5=9B=9B =
=E4=B8=8A=E5=8D=886:15=E5=86=99=E9=81=93=EF=BC=9A
>>=20
>>> On Wed, Mar 31, 2021 at 08:58:17PM +1100, Michael Ellerman wrote:
>>>> So perhaps:
>>>>=20
>>>>  EXC_SYSTEM_RESET
>>>>  EXC_MACHINE_CHECK
>>>>  EXC_DATA_STORAGE
>>>>  EXC_DATA_SEGMENT
>>>>  EXC_INST_STORAGE
>>>>  EXC_INST_SEGMENT
>>>>  EXC_EXTERNAL_INTERRUPT
>>>>  EXC_ALIGNMENT
>>>>  EXC_PROGRAM_CHECK
>>>>  EXC_FP_UNAVAILABLE
>>>>  EXC_DECREMENTER
>>>>  EXC_HV_DECREMENTER
>>>>  EXC_SYSTEM_CALL
>>>>  EXC_HV_DATA_STORAGE
>>>>  EXC_PERF_MONITOR
>>>=20
>>> These are interrupt (vectors), not exceptions.  It doesn't matter =
all
>>> that much, but confusing things more isn't useful either!  There can =
be
>>> multiple exceptions that all can trigger the same interrupt.
>>>=20
>>> When looking at the reference manual of e500 and e600 from NXP
>> official, they call them as interrupts.While looking at the "The
>> Programming Environments"
>> that is also from NXP, they call them exceptions. Looks like there is
>> no explicit distinction between interrupts and exceptions.
>=20
> The architecture documents have always called it interrupts.  The PEM
> says it calls them exceptions instead, but they are called interrupts =
in
> the architecture (and the PEM says that, too).
>=20
>> Here is the "The Programming Environments" link:
>> https://www.nxp.com.cn/docs/en/user-guide/MPCFPE_AD_R1.pdf
>=20
> That document is 24 years old.  The architecture is still published,
> new versions regularly.
>=20
>> As far as I know, the values of interrupts or exceptions above are =
defined
>> explicitly in reference manual or the programming environments.
>=20
> They are defined in the architecture.
>=20
>> Could
>> you please provide more details about multiple exceptions with the =
same
>> interrupts?
>=20
> The simplest example is 700, program interrupt.  There are many causes
> for it, including all the exceptions in FPSCR: VX, ZX, OX, UX, XX, and
> VX is actually divided into nine separate cases itself.  There also =
are
> the various causes of privileged instruction type program interrupts,
> and  the trap type program interrupt, but the FEX ones are most =
obvious
> here.

Thanks for the explanation.

Regards,
Xiongwei

>=20
>=20
> Segher

