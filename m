Return-Path: <kvm-ppc+bounces-115-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CB8838BBF12
	for <lists+kvm-ppc@lfdr.de>; Sun,  5 May 2024 04:15:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 19D2C281CC2
	for <lists+kvm-ppc@lfdr.de>; Sun,  5 May 2024 02:15:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE849ED8;
	Sun,  5 May 2024 02:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D7LzWs9y"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF26EBE
	for <kvm-ppc@vger.kernel.org>; Sun,  5 May 2024 02:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714875344; cv=fail; b=WHfJWhNu9ZqDbFdxXEmRuXcvnZUiBlmSntrnP41DNJAt1KYelFmAspjcMneu4WpZw/R4hU/vX9HHFYbTRgGiWEcy9TEDRMMfFlOvfzXv6bQjUpi3eFXVqZcLyszeA/rCDucH7nS3CIi3RPDJHLJHKI/E6So+U7QE2mqKhQerMig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714875344; c=relaxed/simple;
	bh=MAWIA9rVEXUTt1/1JeApNRhgVCHLT/9PP0kri/Rpxxw=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=o0I7xqoJgbm+IxhG4vzL9iB7HPZqOkNJmV7o6BS48l6hC0q1Q+CLkfSNcEj7+zIF4JVMZccSrKSxTfxOm6PbAgIWh1YdiWKPxjkPvP5eb4jTgCOd8Jc4K+cHxNHfxJ79YMx7vw+MkhDu3WweMOgu9eeohpd6OZA6ZVqSz3yBrMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D7LzWs9y; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714875342; x=1746411342;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=MAWIA9rVEXUTt1/1JeApNRhgVCHLT/9PP0kri/Rpxxw=;
  b=D7LzWs9yvZAfXFHBmCO6h/OC2iP4iVQcA/TYFYJZjYt3gKJvO/h7a+Jh
   RNqRNRi2oFyKc7XPHlvusmXKCzwkQKY+J8N+PTmC33VTHpdTNGG8xhOFY
   NtrejveI5F02d6VmVmmaZ5RDPGpE6V2rFkZ/WKyt6vl5Nh3I9T31brJ2w
   4otdiRxtpkNhCbWygrXrPSC6LBtmW0CqBdTLn1FbI266QMV0/U3XHBQQA
   TZffodxBk2+ByO2gBZb6aF1VX7TLFo34QnyCgE+/5bmIBGy9oRGbQNZqo
   23dMxGlQJpKmYOhVHR8kCiSSWDRItlSpiiyefQOOyTMq0GG8PHzv53Pc9
   w==;
X-CSE-ConnectionGUID: WP1k1KZLSJeAussDA7oFvg==
X-CSE-MsgGUID: rWoln8X4R3GAS+0f29t4Rw==
X-IronPort-AV: E=McAfee;i="6600,9927,11063"; a="33161018"
X-IronPort-AV: E=Sophos;i="6.07,255,1708416000"; 
   d="scan'208";a="33161018"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2024 19:15:42 -0700
X-CSE-ConnectionGUID: nfzR7L/FQlCUBR5UxmXYrw==
X-CSE-MsgGUID: gOsOPG2eS2ymPeFxhkMGdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,255,1708416000"; 
   d="scan'208";a="27907743"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 May 2024 19:15:41 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sat, 4 May 2024 19:15:40 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sat, 4 May 2024 19:15:40 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sat, 4 May 2024 19:15:40 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sat, 4 May 2024 19:15:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E8KCzqEc7RifkrKlShYvDFHLABkFk4zCjlFqOeAdeTjQIJjULEmawyO8QYyWH51aMJSoHVV3yN2/PqM8Qj+Iu0uio+pH3eY9NF2QNeYTWbYQMxqOIdPoyO2hjcaxlz1MopaKecOs1OmzOo1f9ox1SRIX5b2PDukZXxESx9jTwIqQntD02Tw2LnQOXXemdf6ZeaVJWztRrkPj6Off8Or0FmwHEWtzcOS0PeyD/Rl57D/6DX/XpGz0/xYM5pbHce/njTKTkGUUdA/AfBmwhTHa95UCk/GiR3FYSgzATxAh6ZfFrLZ7IL4BHx2uvq+3zelkYViBmzlgvNNSXbjYd/RnJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pd2wo+1TsLEfKd67jTHUzu4OzNe1bJBR8lLIU+ZTy1I=;
 b=WxlQS5Vbacm5ow11WbWGmMvt9NWFT6wjxRdk7EYBuXiolCK3dBbR83dyBY7ByIe7tPHfhTZw1CldynM4wYBJJeTIxWJQ1z19g2RyrEub4cJf1jyNr+93ZTxT70aYYIWQ8+bUGli6hyf36BiZ6UwqOOj0tnSA21tp5H0DZypSC6av8lgNbWD/2cWJpCYHRqTJ8IU+7Hq8FJSXukQweCUtL57BifNVx43K21eUxTp4y0WB0KJlvm7+65Y5Fs6KHROlXifJFF+EGKBk5hA5xVcevdw6d18ahmdKuSDVb7e4LZXMcaJx3xXxAstEhTL+EP50K/teg/K8Ao68u3J0FFPh2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3230.namprd11.prod.outlook.com (2603:10b6:805:b8::29)
 by IA1PR11MB8197.namprd11.prod.outlook.com (2603:10b6:208:446::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.28; Sun, 5 May
 2024 02:15:35 +0000
Received: from SN6PR11MB3230.namprd11.prod.outlook.com
 ([fe80::35d6:c016:dbf5:478e]) by SN6PR11MB3230.namprd11.prod.outlook.com
 ([fe80::35d6:c016:dbf5:478e%7]) with mapi id 15.20.7544.036; Sun, 5 May 2024
 02:15:35 +0000
Date: Sun, 5 May 2024 10:15:28 +0800
From: kernel test robot <lkp@intel.com>
To: Alexander Graf <graf@amazon.com>
CC: <oe-kbuild-all@lists.linux.dev>, <kvm-ppc@vger.kernel.org>
Subject: [agraf-2.6:kvm-kho-gmem-test 19/27] lib/kvm_util.c:202:46: warning:
 unused variable 'region'
Message-ID: <ZjbrwAWnOOcKOmUG@rli9-mobl>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SG2PR04CA0168.apcprd04.prod.outlook.com (2603:1096:4::30)
 To SN6PR11MB3230.namprd11.prod.outlook.com (2603:10b6:805:b8::29)
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3230:EE_|IA1PR11MB8197:EE_
X-MS-Office365-Filtering-Correlation-Id: c4b1ff87-826e-4790-9cf3-08dc6ca93f55
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?D3qXFIkA3BMoKTeZ+65Y5sfptbraIAcoLym3pKV7HeSRZ7V4DmSjwi12k9ez?=
 =?us-ascii?Q?q0i9amOJAeQGldlrD0VRla8jW2hgzXovjwc3DPr30UwW9rhgMIBS05yawIBU?=
 =?us-ascii?Q?bSfQbCGDAKGUZmJZm/i97xpODNjD0ojj2n5gaKVDOqe9uE2F8Az7FmLgVZ7s?=
 =?us-ascii?Q?eh9QczbRjcaVe30lxwEs2QuCuXJZcAvN15JlAgX6DtJFh1vgk6f/Ags2AD7P?=
 =?us-ascii?Q?nWYFQdz8Ldk7tGJfg8Co6SWKsU7lMv5iO5d232lmIW3sUw3EENXunYdi5V4m?=
 =?us-ascii?Q?39frbBoaoqBsEYI1leLTKuUsxM9Hg/WGnVDj7HX8MnepVXCBAjC4nO75C6YK?=
 =?us-ascii?Q?n5tMq6iBWd/m94s1rKQhTtS3rAks5uUOyt14p/O8+FTctqLQ1hgjNjCr5QLg?=
 =?us-ascii?Q?Ah6n6mF8/TbOO6dcIw6FOWi84J3HXxhAHCgwSQW5MUclooYkQx6leorw597z?=
 =?us-ascii?Q?c+Z+FrBV2WERqrXmdTQzf0uNy95ctNJW3Jd14m7bEoW+eIglgVMQCZIkcxq9?=
 =?us-ascii?Q?vHk3v9sgnPtcY70jAzdpGI4Ixh2X4aU9g5qgdq0Bh+ihI/6IiXw2SrmdV+pp?=
 =?us-ascii?Q?m/1TF0DA7cqb72F+ioxMHIR44ow7YVwNHYV/h80v1qZodhNrcQdsi5+TvWR9?=
 =?us-ascii?Q?A3ECQLYCgSwSgZUWP16Qc/aU3j0GOArN64K/nP1pGmvgKs/Q6LDyK2cLeeFW?=
 =?us-ascii?Q?k2GjqVJchgi9IbcgaBtJnEx/dBXadHlTkr1CeDJVE7ul9qYVRPKQwG8nBHr3?=
 =?us-ascii?Q?iZNkzOz1LCmL0yQVrO5+EkjmdwbmxDM6gJT/HaLFxIJrxrDlTDfB0QCgeUUy?=
 =?us-ascii?Q?mgi+AtDYP3xW4OBhL3Yn/vv4S1FlikuK/MFmg+1+EKG3bG4Sz2jw59kjECcy?=
 =?us-ascii?Q?Qv+43YRt+2HwztVI86iuHDWt/ECmhAXSDyCJY4lijNqqMF7QgEtL7nH8as2G?=
 =?us-ascii?Q?AJ9VD1VhD3KL+Toxi4tc1j8oAClnqHroro2PAZxfajKsjznga0xSdznCx5wT?=
 =?us-ascii?Q?ViemcC4GAy+ZsgYMvRJEH0ppf+GceLOaJlvh+WdkPYCb0Bufj5bYHhwoesLU?=
 =?us-ascii?Q?E6EzvanWJ577jGjw2FVOXYWJGbMpCNDhQQZYkXBnqbrHWegIbSITNbA1JrXQ?=
 =?us-ascii?Q?jBvwcaX7q5Am2WFsSXk7aHfQv0AF/RG8FEJ8dZYn9atZKgJ7TfUQpu6fHqQq?=
 =?us-ascii?Q?CJXqkP+unwCdM54tq2eXWXNOC57XmQnPAL1d0FBACk6aJZf7Tnz1ftwrJ1E?=
 =?us-ascii?Q?=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3230.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3ZjQySi4Z6EtWB2B02zLG3HsAD/WhwmHDtwndh6FxLLe3y5CIEHDa28KVzy2?=
 =?us-ascii?Q?9Z3dk1Y23X0mP8WcydCbWRIgud1eIsfPgBiz6d9bs+Ys1aM2TyO0nR1FGcu9?=
 =?us-ascii?Q?aEmXkH97w66ixjXB41mkG6DGOZOijzxN3pYi/iYVT+vd7f7Qczt0Wcjyc13U?=
 =?us-ascii?Q?XFHMiSsinlkksRnT2sqNgaSNzjAc8MMNo8PKW8jkDHdMDgolyy8hqcaoaGkf?=
 =?us-ascii?Q?GCGFA2OBTm5hRIi35VV5xi+g/Ps8LutvqAHGWFLFtq03aRtCY/k/e0Thl9qC?=
 =?us-ascii?Q?lJDXAmW3gPJ3HmQwhjrRcNPI4/CE0MSkfd/lojOEdbo5LyN6ZVx8Te2a6pd2?=
 =?us-ascii?Q?2TB80V/Ko0ygJOWfKGi6awFvLWRBn2BRJ4+Uous4t76cY8m4UaYj2if1qcd2?=
 =?us-ascii?Q?EW0iOsqoFds2VyMubkUquKHLpiWk0Tg5GLrQVYhVyYNfcq2Alr9fiVAoktYf?=
 =?us-ascii?Q?ZPnD4jqC/GH3L2SUxFl9DupRVZdHB+TuH0fBgR1hs30SP4Y4GF29hof0FCZW?=
 =?us-ascii?Q?AzWooZ5g8sUTSjqNKAzS2vobpaGXY/Hdp7/vo77gqRG6Sw6jX+apX6Q2NwPe?=
 =?us-ascii?Q?7aV8dw4041wgb2+2WbXkXm2QmzxvRwtoWHuz4p3NqkTyVTYsRJLtCh8Zdt8j?=
 =?us-ascii?Q?4keAmbfv5hxk5EZaZvBe/lNS0LIz8ZB6QF4Fnqzt5n4s6XkyuX4zJwqL7gKW?=
 =?us-ascii?Q?tWZFjbXUocl6wVV6JjxTsJAD6I3b7aI4ZXK+1xF6cJ8brwFVxJ08c7V75xjg?=
 =?us-ascii?Q?5slHgt0w8Xq6j5ZReQRpz+hVo9YSRLHIVOL5idS0y1cDp7EhYm+pjpXEE4k7?=
 =?us-ascii?Q?kG45vTUytvXpoC9MfGBWPUJLCbm7zfl8fJM+igO+FFhET7e60ltbX+7iaFuz?=
 =?us-ascii?Q?u0wQ+w6J5Q5y1cSX4h+PKRj8HPkcWuvBuACzmeO9UizQWjc6kCw+LQrWzSrn?=
 =?us-ascii?Q?FzZgmaGbLHqWbZ75nMx9y+T2GJSOI47ePrrFnfBJ5Q4s4LvoU18Z6N7eI0C7?=
 =?us-ascii?Q?6UTE7sMqMeRnj72OgrbvhLfkq9npIhFZjhNhk9DCLNg5eOdJJZFJKtc3EbJY?=
 =?us-ascii?Q?uxDORwWyAYxiFQd/d5ZaehNKniXYFJ8e6KosB55Va27fgKYay/k+72OguCyg?=
 =?us-ascii?Q?kYBqIcr2ZBs6+fihs2IzaaXMTkHQhKUx9lvD37n/l3JbPhK1JPPuMuU1V5sn?=
 =?us-ascii?Q?ZbPeLyGOHqtxmjK/TapOBvC1KXC/cfQcn7AbZXkFASQfxFfmSeHBjefoUyO3?=
 =?us-ascii?Q?LKtz3modVIVvYdmwK4DyPHWcv/L1CTVEwjfAGlXGf2F3gkTN1Ted4wUbE0hB?=
 =?us-ascii?Q?7VCs+wjmS76CeBFo4fS8VI2q8MqbBzz5cHjjzJ69VhAzgThDNShTi32sMszZ?=
 =?us-ascii?Q?k1tDTXRoYr64HNS71j2rnkoiZuvl8zJ5gnvfBn5lWoWCWu1eqbRQrQtBH4Rg?=
 =?us-ascii?Q?A6jnfARgnuF0TSS3tFeQUw166AebuKUI5Y73p/4Yiz6RUWgsN4Zgqspr1vc9?=
 =?us-ascii?Q?mSd9O16TxTU0QV6GrQemllK37V2Ligj070LKyLI/PFKc1EuGYXd0MQAv0CJs?=
 =?us-ascii?Q?ncdG4yEQfjzdDSRszMRu39VosmLq4MkCNWUo4wTX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c4b1ff87-826e-4790-9cf3-08dc6ca93f55
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3230.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2024 02:15:35.2727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nwH+AVThpCi0Xusi2ne8mQ6686KS0XRKcEUhOvbyOZIL+VMbXUWqv2ktDdj9w8IDS2X13o57RqiCeHjsDY0+4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8197
X-OriginatorOrg: intel.com

tree:   https://github.com/agraf/linux-2.6.git kvm-kho-gmem-test
head:   9a58862a298a63bad21d05191e28b857063bb9dc
commit: ea39f95803e6da8a46791922be3724b49bea2c7a [19/27] XXX make fdbox work
:::::: branch date: 35 hours ago
:::::: commit date: 7 weeks ago
compiler: gcc-13 (Ubuntu 13.2.0-4ubuntu3) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240505/202405050343.ZgfQxdbN-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/r/202405050343.ZgfQxdbN-lkp@intel.com/

All warnings (new ones prefixed by >>):

   lib/kvm_util.c: In function 'vm_open':
>> lib/kvm_util.c:202:46: warning: unused variable 'region' [-Wunused-variable]
     202 |                 struct userspace_mem_region *region;
         |                                              ^~~~~~
>> lib/kvm_util.c:201:36: warning: unused variable 'node' [-Wunused-variable]
     201 |                 struct hlist_node *node;
         |                                    ^~~~
>> lib/kvm_util.c:200:21: warning: unused variable 'ctr' [-Wunused-variable]
     200 |                 int ctr;
         |                     ^~~
   At top level:
   cc1: note: unrecognized command-line option '-Wno-gnu-variable-sized-type-not-at-end' may have been intended to silence earlier diagnostics


vim +/region +202 tools/testing/selftests/kvm/lib/kvm_util.c

ea39f95803e6da Alexander Graf      2024-03-15  191  
ccc82ba6bea451 Sean Christopherson 2022-02-14  192  static void vm_open(struct kvm_vm *vm)
fa3899add1056f Paolo Bonzini       2018-07-26  193  {
ccc82ba6bea451 Sean Christopherson 2022-02-14  194  	vm->kvm_fd = _open_kvm_dev_path_or_exit(O_RDWR);
fa3899add1056f Paolo Bonzini       2018-07-26  195  
7ed397d107d461 Sean Christopherson 2022-05-27  196  	TEST_REQUIRE(kvm_has_cap(KVM_CAP_IMMEDIATE_EXIT));
c68c21ca929771 Paolo Bonzini       2019-04-11  197  
ea39f95803e6da Alexander Graf      2024-03-15  198  	/* XXX HACK! */
ea39f95803e6da Alexander Graf      2024-03-15  199  	if (old_vmfd) {
ea39f95803e6da Alexander Graf      2024-03-15  200  		int ctr;
ea39f95803e6da Alexander Graf      2024-03-15  201  		struct hlist_node *node;
ea39f95803e6da Alexander Graf      2024-03-15 @202  		struct userspace_mem_region *region;
ea39f95803e6da Alexander Graf      2024-03-15  203  
ea39f95803e6da Alexander Graf      2024-03-15  204  		/* Recover old VM fd */
ea39f95803e6da Alexander Graf      2024-03-15  205  		vm->fd = old_vmfd;
ea39f95803e6da Alexander Graf      2024-03-15  206  	} else
fcba483e824628 Sean Christopherson 2022-06-01  207  		vm->fd = __kvm_ioctl(vm->kvm_fd, KVM_CREATE_VM, (void *)vm->type);
f9725f89dc5027 Sean Christopherson 2022-02-15  208  	TEST_ASSERT(vm->fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_VM, vm->fd));
fa3899add1056f Paolo Bonzini       2018-07-26  209  }
fa3899add1056f Paolo Bonzini       2018-07-26  210  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


